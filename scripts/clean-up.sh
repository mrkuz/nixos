#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/lib/common.sh"

KEEP_GENERATIONS="1"

function clean() {
    profile="$1"
    if [[ -d "$profile" ]]; then
        echo ">>> $profile"
        sudo env "PATH=$PATH" nix-env --delete-generations +"$KEEP_GENERATIONS" --profile $profile
    fi
}

for path in /nix/var/nix/profiles/per-user/*; do
    user=${path##*/}
    clean /nix/var/nix/profiles/per-user/$user/home-manager
    clean /nix/var/nix/profiles/per-user/$user/channels
    clean /nix/var/nix/profiles/per-user/$user/profile
    clean /home/$user/.nix-profile
    clean /home/$user/.local/state/nix/profiles/home-manager
done

clean /root/.nix-profile
clean /root/.local/state/nix/profiles/home-manager
clean /nix/var/nix/profiles/system

sudo env "PATH=$PATH" nix-collect-garbage
