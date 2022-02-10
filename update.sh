#!/usr/bin/env bash

set -e

BRANCH="nixos-unstable"
REMOTE="origin"
NIXPKGS="/nix/nixpkgs"

if [[ ! -e "$NIXPKGS" ]]; then
  sudo git clone https://github.com/NixOS/nixpkgs.git "$NIXPKGS"
fi

pushd . >& /dev/null
cd "$NIXPKGS"

current_branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
if [[ $current_branch != "$BRANCH" ]]; then
  sudo git checkout "$BRANCH"
fi

sudo git fetch $REMOTE
if git diff $BRANCH $REMOTE/$BRANCH --quiet --exit-code; then
  echo "nixpkgs already up to date";
else
  git diff $BRANCH $REMOTE/$BRANCH --stat
fi

sudo git pull
popd

git submodule update --recursive --remote
nix flake update
git diff flake.lock
niv update
git diff nix/sources.json

if [[ -e "/etc/nixos/options.json" ]]; then
  nix-build /nix/nixpkgs/nixos/release.nix -A options -o tmp/options
  diff -u --color=always <(jq keys /etc/nixos/options.json) <(jq keys tmp/options/share/doc/nixos/options.json) | less
  rm tmp/options
fi
