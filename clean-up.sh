#!/usr/bin/env bash

set -e

KEEP_GENERATIONS="1"

nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/$USER/home-manager
nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/$USER/channels
nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/$USER/profile
nix-env --delete-generations +"$KEEP_GENERATIONS" --profile $HOME/.nix-profile
sudo nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/root/channels
sudo nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/system

sudo nix-collect-garbage
