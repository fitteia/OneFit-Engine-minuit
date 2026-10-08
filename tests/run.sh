#!/usr/bin/env bash
# Builds libminuit.a and runs the smoke test(s) against it.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
work="$(mktemp -d)"
trap 'rm -rf -- "$work"' EXIT
make -C "$here/.." lib >/dev/null
gfortran -O2 -std=legacy "$here/rosenbrock.F" "$here/../libminuit.a" -o "$work/rosenbrock"
"$work/rosenbrock" > "$work/out.txt" 2>&1 || { cat "$work/out.txt"; exit 1; }
grep -E 'minimum at|PASS' "$work/out.txt"
