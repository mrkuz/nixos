# Example installation on Ubuntu

- Install nix

  ```shell
  sh <(curl -L https://nixos.org/nix/install) --daemon
  ```

- Add yourself as trusted user to `/etc/nix/nix.conf`

  ```
  trusted-users = root user
  ```

- Clone repository

  ```shell
  mkdir ~/etc
  cd ~/etc
  git clone https://github.com/mrkuz/nixos.git
  cd nixos
  ```

- Change `dotfiles.url` in `flake.nix` to point to the GitHub repository, not local directory.

  ```nix
  {
    dotfiles = {
      url = "github:mrkuz/dotfiles";
      flake = false;
    };
  }
  ```

- Initialize submodules

  ```shell
  git submodule init
  git submodule update
  ```

- Clone nixpkgs (optional)

  ```shell
  sudo git clone https://github.com/NixOS/nixpkgs.git /nix/nixpkgs
  cd /nix/nixpkgs
  sudo git checkout nixos-unstable
  ```

- Update inputs and install

  ```shell
  export NIX_CONFIG="experimental-features = nix-command flakes"
  ./scripts/update.sh
  nix build .#user@ubuntu
  ./result/activate
  ```
