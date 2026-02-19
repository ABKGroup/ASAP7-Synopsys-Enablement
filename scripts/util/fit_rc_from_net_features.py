#!/usr/bin/env python3
import argparse
import re
from pathlib import Path

import numpy as np
import pandas as pd


def parse_args():
    ap = argparse.ArgumentParser(
        description="Fit metal/via resistance coefficients from per-net resistance and extracted features."
    )
    ap.add_argument("--parasitics", required=True, help="Path to net_parasitics.csv")
    ap.add_argument("--metal", required=True, help="Path to net_metal_lengths.csv")
    ap.add_argument("--via", required=True, help="Path to net_via_counts.csv")
    ap.add_argument("--outdir", required=True, help="Output directory")
    ap.add_argument(
        "--metal-length-col",
        default="auto",
        choices=["auto", "total_length_um", "total_length_dbu"],
        help="Metal length feature column (auto picks a non-empty one)",
    )
    ap.add_argument(
        "--alpha",
        type=float,
        default=1e-8,
        help="Ridge regularization factor (>=0)",
    )
    ap.add_argument(
        "--val-ratio",
        type=float,
        default=0.2,
        help="Validation split ratio in [0, 0.9)",
    )
    ap.add_argument("--seed", type=int, default=7, help="Random seed for split")
    ap.add_argument(
        "--nonneg",
        action="store_true",
        help="Clamp fitted coefficients to non-negative values after solve",
    )
    ap.add_argument(
        "--metal-groups",
        default="",
        help='Comma-separated groups, e.g. "M1:M2:M3,M4:M5,M6:M7". '
             "Layers in a group share one fitted coefficient.",
    )
    ap.add_argument(
        "--via-group-by-layer-pair",
        dest="via_group_by_layer_pair",
        action="store_true",
        help="Group via features by layer pair (e.g. M1-M2) before fitting.",
    )
    ap.add_argument(
        "--no-via-group-by-layer-pair",
        dest="via_group_by_layer_pair",
        action="store_false",
        help="Disable via layer-pair grouping and use raw via types.",
    )
    ap.set_defaults(via_group_by_layer_pair=False)
    return ap.parse_args()


def _pick_metal_length_col(m: pd.DataFrame, requested: str):
    candidates = []
    if requested == "auto":
        candidates = ["total_length_um", "total_length_dbu"]
    else:
        candidates = [requested] + [c for c in ["total_length_um", "total_length_dbu"] if c != requested]

    for col in candidates:
        if col not in m.columns:
            continue
        s = pd.to_numeric(m[col], errors="coerce")
        non_nan = int(s.notna().sum())
        non_zero = int((s.fillna(0.0).abs() > 0.0).sum())
        if non_nan > 0 and non_zero > 0:
            return col

    # Fallback: return the first available candidate even if sparse/zero.
    for col in candidates:
        if col in m.columns:
            return col

    raise ValueError("metal file must contain one of: total_length_um, total_length_dbu")


def load_and_prepare(parasitics_path: Path, metal_path: Path, via_path: Path, metal_length_col: str):
    p = pd.read_csv(parasitics_path)
    m = pd.read_csv(metal_path)
    v = pd.read_csv(via_path)

    required_p = {"net_name", "res"}
    required_m = {"net_name", "layer_name"}
    required_v = {"net_name", "via_name", "count"}

    if not required_p.issubset(p.columns):
        raise ValueError(f"parasitics missing columns: {sorted(required_p - set(p.columns))}")
    if not required_m.issubset(m.columns):
        raise ValueError(f"metal missing columns: {sorted(required_m - set(m.columns))}")
    if not required_v.issubset(v.columns):
        raise ValueError(f"via missing columns: {sorted(required_v - set(v.columns))}")

    p = p[["net_name", "res"]].copy()
    p["res"] = pd.to_numeric(p["res"], errors="coerce")
    p = p.dropna(subset=["res"]).drop_duplicates(subset=["net_name"])

    chosen_metal_col = _pick_metal_length_col(m, metal_length_col)
    m = m[["net_name", "layer_name", chosen_metal_col]].copy()
    m[chosen_metal_col] = pd.to_numeric(m[chosen_metal_col], errors="coerce").fillna(0.0)
    m = m.pivot_table(
        index="net_name",
        columns="layer_name",
        values=chosen_metal_col,
        aggfunc="sum",
        fill_value=0.0,
    )
    m.columns = [f"METAL::{c}" for c in m.columns]

    v = v[["net_name", "via_name", "count"]].copy()
    v["count"] = pd.to_numeric(v["count"], errors="coerce").fillna(0.0)
    v = v.pivot_table(
        index="net_name",
        columns="via_name",
        values="count",
        aggfunc="sum",
        fill_value=0.0,
    )
    v.columns = [f"VIA::{c}" for c in v.columns]

    x = m.join(v, how="outer").fillna(0.0)
    df = p.merge(x, left_on="net_name", right_index=True, how="inner")
    if df.empty:
        raise ValueError("No overlapping nets among parasitics/metal/via files")

    feature_cols = [c for c in df.columns if c.startswith("METAL::") or c.startswith("VIA::")]
    if not feature_cols:
        raise ValueError("No feature columns found after pivot")

    return df, feature_cols, chosen_metal_col


def apply_metal_groups(df: pd.DataFrame, feature_cols, groups_arg: str):
    if not groups_arg.strip():
        return df, feature_cols, {}

    metal_cols = [c for c in feature_cols if c.startswith("METAL::")]
    via_cols = [c for c in feature_cols if c.startswith("VIA::")]
    metal_set = set(metal_cols)

    group_map = {}  # METAL::Mx -> group_name
    new_group_cols = []

    groups = [g.strip() for g in groups_arg.split(",") if g.strip()]
    for g in groups:
        layers = [x.strip() for x in g.split(":") if x.strip()]
        if len(layers) < 2:
            continue
        group_name = "METAL_GROUP::" + ":".join(layers)
        src_cols = []
        for lyr in layers:
            col = f"METAL::{lyr}"
            if col in metal_set:
                src_cols.append(col)
                group_map[col] = group_name
        if not src_cols:
            continue
        df[group_name] = df[src_cols].sum(axis=1)
        new_group_cols.append(group_name)

    # Keep ungrouped metal columns as-is.
    ungrouped_metal = [c for c in metal_cols if c not in group_map]
    new_feature_cols = ungrouped_metal + new_group_cols + via_cols
    return df, new_feature_cols, group_map


def _extract_via_layer_pair(via_type: str):
    # Pattern 1: VIA12, VIA23, VIA78 ...
    m = re.match(r"^VIA(\d+)(\d+)", via_type, re.IGNORECASE)
    if m:
        a = int(m.group(1))
        b = int(m.group(2))
        lo, hi = sorted([a, b])
        return f"M{lo}-M{hi}"

    # Pattern 2: M2_M1_..., M4_M3wide..., M7_M6_...
    m = re.match(r"^M(\d+)_M(\d+)", via_type, re.IGNORECASE)
    if m:
        a = int(m.group(1))
        b = int(m.group(2))
        lo, hi = sorted([a, b])
        return f"M{lo}-M{hi}"

    return "UNKNOWN"


def apply_via_layer_pair_grouping(df: pd.DataFrame, feature_cols):
    via_cols = [c for c in feature_cols if c.startswith("VIA::")]
    metal_cols = [c for c in feature_cols if not c.startswith("VIA::")]
    if not via_cols:
        return df, feature_cols

    pair_to_cols = {}
    for c in via_cols:
        via_type = c.replace("VIA::", "", 1)
        pair = _extract_via_layer_pair(via_type)
        g = f"VIA_PAIR::{pair}"
        pair_to_cols.setdefault(g, []).append(c)

    grouped_cols = []
    for g, cols in pair_to_cols.items():
        df[g] = df[cols].sum(axis=1)
        grouped_cols.append(g)

    return df, metal_cols + grouped_cols


def fit_ridge(x: np.ndarray, y: np.ndarray, alpha: float):
    # theta = (X^T X + alpha I)^-1 X^T y
    xtx = x.T @ x
    if alpha > 0:
        xtx = xtx + alpha * np.eye(xtx.shape[0])
    xty = x.T @ y
    return np.linalg.solve(xtx, xty)


def metrics(y_true: np.ndarray, y_pred: np.ndarray):
    eps = 1e-12
    err = y_pred - y_true
    mae = float(np.mean(np.abs(err)))
    rmse = float(np.sqrt(np.mean(err ** 2)))
    mape = float(np.mean(np.abs(err) / np.maximum(np.abs(y_true), eps)) * 100.0)
    sst = float(np.sum((y_true - np.mean(y_true)) ** 2))
    sse = float(np.sum((y_true - y_pred) ** 2))
    r2 = 1.0 - (sse / sst) if sst > 0 else 0.0
    return {"mae": mae, "rmse": rmse, "mape_pct": mape, "r2": r2}


def main():
    args = parse_args()

    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    df, feature_cols, chosen_metal_col = load_and_prepare(
        Path(args.parasitics), Path(args.metal), Path(args.via), args.metal_length_col
    )
    df, feature_cols, group_map = apply_metal_groups(df, feature_cols, args.metal_groups)
    if args.via_group_by_layer_pair:
        df, feature_cols = apply_via_layer_pair_grouping(df, feature_cols)

    rng = np.random.default_rng(args.seed)
    idx = np.arange(len(df))
    rng.shuffle(idx)

    n_val = int(len(df) * args.val_ratio)
    n_val = min(max(n_val, 0), max(len(df) - 1, 0))

    val_idx = idx[:n_val]
    trn_idx = idx[n_val:]
    if len(trn_idx) == 0:
        raise ValueError("No training samples left after split; reduce --val-ratio")

    train = df.iloc[trn_idx].copy()
    valid = df.iloc[val_idx].copy() if n_val > 0 else pd.DataFrame(columns=df.columns)

    x_train = train[feature_cols].to_numpy(dtype=float)
    y_train = train["res"].to_numpy(dtype=float)

    # Include intercept as the first column.
    x_train_i = np.hstack([np.ones((x_train.shape[0], 1)), x_train])
    theta = fit_ridge(x_train_i, y_train, max(args.alpha, 0.0))

    if args.nonneg:
        theta[1:] = np.maximum(theta[1:], 0.0)

    # Predict train/val/full
    x_full = df[feature_cols].to_numpy(dtype=float)
    x_full_i = np.hstack([np.ones((x_full.shape[0], 1)), x_full])
    y_full = df["res"].to_numpy(dtype=float)
    y_full_pred = x_full_i @ theta

    x_tr_i = np.hstack([np.ones((x_train.shape[0], 1)), x_train])
    y_tr_pred = x_tr_i @ theta

    tr_metrics = metrics(y_train, y_tr_pred)
    full_metrics = metrics(y_full, y_full_pred)

    if n_val > 0:
        x_val = valid[feature_cols].to_numpy(dtype=float)
        y_val = valid["res"].to_numpy(dtype=float)
        x_val_i = np.hstack([np.ones((x_val.shape[0], 1)), x_val])
        y_val_pred = x_val_i @ theta
        val_metrics = metrics(y_val, y_val_pred)
    else:
        val_metrics = None

    # Save coefficient tables.
    coef = pd.DataFrame(
        {
            "feature": ["INTERCEPT"] + feature_cols,
            "coef": theta,
        }
    )
    coef.to_csv(outdir / "fitted_rc_coefficients.csv", index=False)

    metal_coef = coef[
        coef["feature"].str.startswith("METAL::")
        | coef["feature"].str.startswith("METAL_GROUP::")
    ].copy()
    via_coef = coef[
        coef["feature"].str.startswith("VIA::")
        | coef["feature"].str.startswith("VIA_PAIR::")
    ].copy()
    metal_coef.to_csv(outdir / "fitted_metal_coefficients.csv", index=False)
    via_coef.to_csv(outdir / "fitted_via_coefficients.csv", index=False)

    # Clean summary tables requested by flow users.
    metal_table = metal_coef.rename(columns={"coef": "sheet_resistance_ohm_per_um"}).copy()
    metal_rows = []
    for _, row in metal_table.iterrows():
        feat = row["feature"]
        coef_val = row["sheet_resistance_ohm_per_um"]
        if feat.startswith("METAL::"):
            metal_rows.append((feat.replace("METAL::", ""), coef_val))
        elif feat.startswith("METAL_GROUP::"):
            group_text = feat.replace("METAL_GROUP::", "")
            for lyr in group_text.split(":"):
                metal_rows.append((lyr, coef_val))
    metal_table = pd.DataFrame(metal_rows, columns=["metal_layer", "sheet_resistance_ohm_per_um"])
    metal_table = metal_table.sort_values("metal_layer").drop_duplicates(subset=["metal_layer"], keep="last")
    metal_table.to_csv(outdir / "metal_sheet_resistance.csv", index=False)

    via_table = via_coef.rename(columns={"coef": "via_resistance_ohm"}).copy()
    via_table["via_type"] = (
        via_table["feature"]
        .str.replace("VIA::", "", regex=False)
        .str.replace("VIA_PAIR::", "", regex=False)
    )
    via_table = via_table[["via_type", "via_resistance_ohm"]].sort_values("via_type")
    via_table.to_csv(outdir / "via_resistance.csv", index=False)

    # Always emit a layer-pair summary for via resistance.
    # If fit already used VIA_PAIR features, this is a direct table.
    if any(via_coef["feature"].str.startswith("VIA_PAIR::")):
        via_pair_table = via_coef[via_coef["feature"].str.startswith("VIA_PAIR::")].copy()
        via_pair_table["layer_pair"] = via_pair_table["feature"].str.replace("VIA_PAIR::", "", regex=False)
        via_pair_table = via_pair_table.rename(columns={"coef": "via_resistance_ohm"})
        via_pair_table = via_pair_table[["layer_pair", "via_resistance_ohm"]].sort_values("layer_pair")
    else:
        # Build weighted average by observed via counts per type.
        via_feature_cols = [c for c in df.columns if c.startswith("VIA::")]
        usage = {}
        for c in via_feature_cols:
            usage[c] = float(df[c].sum())
        rows = []
        for _, row in via_coef[via_coef["feature"].str.startswith("VIA::")].iterrows():
            feat = row["feature"]
            via_type = feat.replace("VIA::", "", 1)
            pair = _extract_via_layer_pair(via_type)
            rows.append((pair, float(row["coef"]), usage.get(feat, 0.0)))
        tmp = pd.DataFrame(rows, columns=["layer_pair", "coef", "weight"])
        if tmp.empty:
            via_pair_table = pd.DataFrame(columns=["layer_pair", "via_resistance_ohm"])
        else:
            grouped = []
            for pair, gdf in tmp.groupby("layer_pair"):
                w = gdf["weight"].to_numpy(dtype=float)
                c = gdf["coef"].to_numpy(dtype=float)
                if np.sum(w) > 0:
                    r = float(np.sum(c * w) / np.sum(w))
                else:
                    r = float(np.mean(c))
                grouped.append((pair, r))
            via_pair_table = pd.DataFrame(grouped, columns=["layer_pair", "via_resistance_ohm"]).sort_values("layer_pair")
    via_pair_table.to_csv(outdir / "via_resistance_by_layer_pair.csv", index=False)

    pred = df[["net_name", "res"]].copy()
    pred["res_pred"] = y_full_pred
    pred["abs_err"] = np.abs(pred["res_pred"] - pred["res"])
    pred.to_csv(outdir / "net_resistance_predictions.csv", index=False)

    with (outdir / "fit_report.txt").open("w") as f:
        f.write(f"num_nets={len(df)}\n")
        f.write(f"num_features={len(feature_cols)}\n")
        f.write(f"alpha={args.alpha}\n")
        f.write(f"nonneg={args.nonneg}\n")
        f.write(f"metal_length_col={chosen_metal_col}\n")
        f.write(f"metal_groups={args.metal_groups}\n")
        f.write(f"via_group_by_layer_pair={args.via_group_by_layer_pair}\n")
        f.write(f"grouped_metal_features={len([c for c in feature_cols if c.startswith('METAL_GROUP::')])}\n")
        f.write(f"grouped_via_pair_features={len([c for c in feature_cols if c.startswith('VIA_PAIR::')])}\n")
        f.write("\n[train]\n")
        for k, v in tr_metrics.items():
            f.write(f"{k}={v}\n")
        if val_metrics is not None:
            f.write("\n[val]\n")
            for k, v in val_metrics.items():
                f.write(f"{k}={v}\n")
        f.write("\n[full]\n")
        for k, v in full_metrics.items():
            f.write(f"{k}={v}\n")

    print("Wrote:")
    print(f"  selected_metal_length_col={chosen_metal_col}")
    print(f"  {outdir / 'fitted_rc_coefficients.csv'}")
    print(f"  {outdir / 'fitted_metal_coefficients.csv'}")
    print(f"  {outdir / 'fitted_via_coefficients.csv'}")
    print(f"  {outdir / 'metal_sheet_resistance.csv'}")
    print(f"  {outdir / 'via_resistance.csv'}")
    print(f"  {outdir / 'via_resistance_by_layer_pair.csv'}")
    print(f"  {outdir / 'net_resistance_predictions.csv'}")
    print(f"  {outdir / 'fit_report.txt'}")


if __name__ == "__main__":
    main()
