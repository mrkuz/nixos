#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/lib/common.sh"

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
# nixos-rebuild -vv --show-trace --keep-going -j 2 --flake ".#$1" build
nixos-rebuild -vv --keep-going -j 2 --flake ".#$1" build

nix-store --query --requisites /run/current-system/ | cut -d- -f2- | sort | uniq > tmp/packages.old
nix-store --query --requisites result/ | cut -d- -f2- | sort | uniq > tmp/packages.new
diff -u --color=always tmp/packages.{old,new} | less

nixos-rebuild -j 2 --use-remote-sudo --flake ".#$1" switch
