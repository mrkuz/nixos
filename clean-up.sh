#!/usr/bin/env bash

set -e

KEEP_GENERATIONS="1"

nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/$USER/home-manager
nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/$USER/channels
nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/$USER/profile
nix-env --delete-generations +"$KEEP_GENERATIONS" --profile $HOME/.nix-profile
sudo env "PATH=$PATH" nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/per-user/root/channels
sudo env "PATH=$PATH" nix-env --delete-generations +"$KEEP_GENERATIONS" --profile /nix/var/nix/profiles/system

sudo env "PATH=$PATH" nix-collect-garbage
