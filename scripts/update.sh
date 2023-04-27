#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/lib/common.sh"

NIXPKGS="/nix/nixpkgs"
NIXPKGS_BRANCH="nixos-unstable"

HOME_MANAGER="/nix/home-manager"
HOME_MANAGER_BRANCH="master"

git submodule update --recursive --remote
nix flake update
git diff flake.lock

command -v niv && niv update
git diff nix/sources.json

function pull() {
  directory=$1
  branch=$2

  if [[ ! -e "$directory" ]]; then
    return
  fi

  pushd . >& /dev/null
  cd "$directory"

  current_branch="$(sudo git symbolic-ref --short HEAD 2>/dev/null)"
  if [[ $current_branch != "$branch" ]]; then
    sudo git checkout "$branch"
  fi

  sudo git fetch origin
  if sudo git diff $branch origin/$branch --quiet --exit-code; then
    echo "$directory already up to date";
  else
    sudo git diff $branch origin/$branch --stat
  fi

  sudo git pull
  popd
}

pull $NIXPKGS $NIXPKGS_BRANCH

if [[ -e "$NIXPKGS" ]]; then
  if [[ -e "/etc/nixos/options.json" ]]; then
    nix-build "$NIXPKGS/nixos/release.nix" -A options -o tmp/options
    diff -u --color=always <(jq keys /etc/nixos/options.json) <(jq keys tmp/options/share/doc/nixos/options.json) | less
    rm tmp/options
  fi
fi

pull $HOME_MANAGER $HOME_MANAGER_BRANCH

