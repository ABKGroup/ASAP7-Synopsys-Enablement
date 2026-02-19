#!/usr/bin/env python3
import argparse
import csv
from pathlib import Path

import matplotlib.pyplot as plt


def load_points(path: Path):
    groups = {"over": ([], []), "under": ([], []), "excluded": ([], [])}
    with path.open("r", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            pos = row.get("position", "").strip().lower()
            if pos not in groups:
                continue
            try:
                x = float(row["x"])
                y = float(row["y"])
            except (KeyError, ValueError):
                continue
            groups[pos][0].append(x)
            groups[pos][1].append(y)
    return groups


def main():
    ap = argparse.ArgumentParser(description="Plot Ostrich VS points CSV to PNG.")
    ap.add_argument("--input", required=True, help="Input CSV path from ostrich_export_vs_points.tcl")
    ap.add_argument("--output", required=True, help="Output PNG path")
    ap.add_argument("--title", required=True, help="Plot title")
    args = ap.parse_args()

    groups = load_points(Path(args.input))
    all_x = groups["over"][0] + groups["under"][0] + groups["excluded"][0]
    all_y = groups["over"][1] + groups["under"][1] + groups["excluded"][1]
    if not all_x:
        raise SystemExit(f"No points found in {args.input}")

    lo = min(min(all_x), min(all_y))
    hi = max(max(all_x), max(all_y))
    span = hi - lo
    pad = span * 0.05 if span > 0 else 1.0

    plt.figure(figsize=(9, 7))
    if groups["under"][0]:
        plt.scatter(groups["under"][0], groups["under"][1], s=6, c="#1f77b4", label="under", alpha=0.8)
    if groups["over"][0]:
        plt.scatter(groups["over"][0], groups["over"][1], s=6, c="#d62728", label="over", alpha=0.8)
    if groups["excluded"][0]:
        plt.scatter(groups["excluded"][0], groups["excluded"][1], s=8, c="#7f7f7f", label="excluded", alpha=0.7)

    plt.plot([lo - pad, hi + pad], [lo - pad, hi + pad], "k-", linewidth=1.0)
    plt.xlim(lo - pad, hi + pad)
    plt.ylim(lo - pad, hi + pad)
    plt.xlabel("Golden")
    plt.ylabel("Target")
    plt.title(args.title)
    plt.legend(loc="best", frameon=True)
    plt.grid(True, linestyle="--", linewidth=0.4, alpha=0.5)
    plt.tight_layout()
    plt.savefig(args.output, dpi=220)
    plt.close()


if __name__ == "__main__":
    main()
