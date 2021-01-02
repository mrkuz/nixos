#!/usr/bin/env bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 HOST"
  exit 1;
fi

sudo nixos-rebuild -vv --flake ".#$1" switch
