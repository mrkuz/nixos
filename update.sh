#!/usr/bin/env bash

set -e

function ask() {
  while true; do
    read -p "$1 [y/n/a]? " yn
    case $yn in
      [Yy]*) return 0;;
      [Nn]*) return 1;;
      [Aa]*) echo "Aborted"; exit 1;;
      *) echo "Invalid answer";;
    esac
  done
}

BRANCH="nixos-unstable"
REMOTE="origin"
NIXPKGS="/nix/nixpkgs"

pushd . >& /dev/null
cd "$NIXPKGS"

sudo git fetch $REMOTE
if git diff $BRANCH $REMOTE/$BRANCH --quiet --exit-code; then
  echo "Already up to date";
else
  git diff $BRANCH $REMOTE/$BRANCH --stat
  if ask "Show details"; then
    git diff $BRANCH $REMOTE/$BRANCH -p
  fi
fi

current_branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
if [[ $current_branch != "$BRANCH" ]]; then
  sudo git checkout "$BRANCH"
fi

sudo git pull

popd

git submodule update --recursive --remote
nix flake update --recreate-lock-file
git diff flake.lock
niv update
git diff nix/sources.json
