#!/usr/bin/env bash

set -e

function clean() {
  rm ./result
  rm tmp/packages.*
}

trap clean EXIT

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 HOST"
  exit 1;
fi

if [[ -L "./result" ]]; then
  rm ./result
fi
sudo nixos-rebuild -vv --keep-going -j 2 --flake ".#$1" build

OPTIONS="etc/nixos/options.json"
if [[ -e "/$OPTIONS" ]]; then
  diff -u --color=always <(jq keys "/$OPTIONS") <(jq keys "result/$OPTIONS") | less
fi

nix-store --query --requisites /run/current-system/ | cut -d- -f2- | sort | uniq > tmp/packages.old
nix-store --query --requisites result/ | cut -d- -f2- | sort | uniq > tmp/packages.new
diff -u --color=always tmp/packages.{old,new} | less

sudo nixos-rebuild -j 2 --flake ".#$1" switch
