#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 || $# -gt 5 ]]; then
  echo "Usage: $0 <spef1> <spef2> <outdir> [set1_name] [set2_name]" >&2
  exit 2
fi

spef1="$1"
spef2="$2"
outdir="$3"
set1_name="${4:-set1}"
set2_name="${5:-set2}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tcl_script="$script_dir/ostrich_export_vs_points.tcl"
plot_py="$script_dir/plot_ostrich_vs.py"
ostrich_bin="${OSTRICH_BIN:-ostrich}"

if [[ "$ostrich_bin" == */* ]]; then
  if [[ ! -x "$ostrich_bin" ]]; then
    echo "ERROR: OSTRICH_BIN is not executable: $ostrich_bin" >&2
    exit 1
  fi
else
  if ! command -v "$ostrich_bin" >/dev/null 2>&1; then
    echo "ERROR: '$ostrich_bin' not found in PATH. Set OSTRICH_BIN=/full/path/to/ostrich or load tool env first." >&2
    exit 1
  fi
fi

mkdir -p "$outdir"

export OSTRICH_SPEF1="$spef1"
export OSTRICH_SPEF2="$spef2"
export OSTRICH_SET1_NAME="$set1_name"
export OSTRICH_SET2_NAME="$set2_name"
export OSTRICH_OUTPUT_DIR="$outdir"

log_file="$outdir/ostrich_nowin.log"
set +e
"$ostrich_bin" -nowin >"$log_file" 2>&1 <<EOF
source $tcl_script
exit
EOF
rc=$?
set -e
if [[ $rc -ne 0 ]]; then
  echo "ERROR: Ostrich failed (rc=$rc). See log: $log_file" >&2
  tail -n 80 "$log_file" >&2 || true
  exit 1
fi

if [[ ! -f "$outdir/tcap_vs_points.csv" || ! -f "$outdir/res_vs_points.csv" ]]; then
  echo "ERROR: Ostrich completed but expected CSV files were not generated." >&2
  echo "Missing: $outdir/tcap_vs_points.csv and/or $outdir/res_vs_points.csv" >&2
  echo "See log: $log_file" >&2
  tail -n 80 "$log_file" >&2 || true
  exit 1
fi

python3 "$plot_py" \
  --input "$outdir/tcap_vs_points.csv" \
  --output "$outdir/net_capacitance.png" \
  --title "${set2_name} vs ${set1_name} tcap"

python3 "$plot_py" \
  --input "$outdir/res_vs_points.csv" \
  --output "$outdir/net_resistance.png" \
  --title "${set2_name} vs ${set1_name} res"

# Write a compact summary with recommended scale factors.
summary_file="$outdir/recommended_scale_factors.txt"
{
  echo "plotname=${set1_name}_vs_${set2_name}"
  if [[ -f "$outdir/tcap_stats.txt" ]]; then
    grep -E '^(datatype|golden|target|applied_scale_factor|recommended_scale_factor)=' "$outdir/tcap_stats.txt"
  fi
  if [[ -f "$outdir/res_stats.txt" ]]; then
    grep -E '^(datatype|golden|target|applied_scale_factor|recommended_scale_factor)=' "$outdir/res_stats.txt"
  fi
} >"$summary_file"

# Keep only plots and the scale-factor summary.
find "$outdir" -maxdepth 1 -type f \
  ! -name "net_capacitance.png" \
  ! -name "net_resistance.png" \
  ! -name "recommended_scale_factors.txt" \
  -delete

echo "Generated:"
echo "  $outdir/net_capacitance.png"
echo "  $outdir/net_resistance.png"
echo "  $outdir/recommended_scale_factors.txt"
