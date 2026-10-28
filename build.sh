#!/usr/bin/env bash
# Usage: ./build.sh            -> build all variants
#        ./build.sh name ...   -> build specific variants (file names in variants/ without .yaml)
set -euo pipefail
cd "$(dirname "$0")"
today="$(date +%Y-%m-%d)"
outdir="out/$today"
mkdir -p "$outdir"
variants=("$@")
[ ${#variants[@]} -eq 0 ] && variants=($(ls variants | sed 's/\.yaml$//'))
for v in "${variants[@]}"; do
  typst compile --root . --input variant="$v" main.typ "$outdir/Prashant_Piprotar_${v}_${today}.pdf"
  echo "built $outdir/Prashant_Piprotar_${v}_${today}.pdf"
done
