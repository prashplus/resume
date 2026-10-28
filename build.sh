#!/usr/bin/env bash
# Usage: ./build.sh            -> build all variants
#        ./build.sh name ...   -> build specific variants (file names in variants/ without .yaml)
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p out
variants=("$@")
[ ${#variants[@]} -eq 0 ] && variants=($(ls variants | sed 's/\.yaml$//'))
for v in "${variants[@]}"; do
  typst compile --root . --input variant="$v" main.typ "out/Prashant_Piprotar_${v}.pdf"
  echo "built out/Prashant_Piprotar_${v}.pdf"
done
