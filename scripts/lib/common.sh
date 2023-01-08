set -e

if [[ ! -f "flake.nix" ]]; then
  echo "Not in root directory"
  exit 1
fi
