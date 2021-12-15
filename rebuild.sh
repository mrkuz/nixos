#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 HOST"
  exit 1;
fi

if [[ -L "./result" ]]; then
  rm ./result
fi
sudo nixos-rebuild -vv --keep-going -j 2 --flake ".#$1" build

OPTIONS="etc/nixos/options.json"
PACKAGES="etc/nixos/system-packages"

if [[ -e "/$OPTIONS" ]]; then
  diff -u --color=always <(jq keys "/$OPTIONS") <(jq keys "result/$OPTIONS") | less
fi

if [[ -e "/$PACKAGES" ]]; then
  diff -u --color=always "/$PACKAGES" "result/$PACKAGES" | less
fi

rm ./result
sudo nixos-rebuild -j 2 --flake ".#$1" switch
