#!/usr/bin/env bash

set -e

BRANCH="master"
REMOTE="origin"
NIXPKGS="/nix/nixpkgs"

pushd . >& /dev/null
cd "$NIXPKGS"

sudo git fetch $REMOTE
if git diff $BRANCH $REMOTE/$BRANCH --quiet --exit-code; then
  echo "nixpkgs already up to date";
else
  git diff $BRANCH $REMOTE/$BRANCH --stat
fi

current_branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
if [[ $current_branch != "$BRANCH" ]]; then
  sudo git checkout "$BRANCH"
fi

sudo git pull
popd

git submodule update --recursive --remote
nix flake update
git diff flake.lock
niv update
git diff nix/sources.json
