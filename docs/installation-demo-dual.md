# Example Ubuntu/NixOS dual boot installation (qemu-kvm, UEFI, LUKS, BTRFS, grub2)

## Preparation

- Install and boot Ubuntu ([see example](https://github.com/mrkuz/Notes/blob/main/20220918185954-ubuntu_luks.org))

- Install nix

  ```shell
  sh <(curl -L https://nixos.org/nix/install) --daemon
  ```

- Switch to root user

## File system

- Create filesystems

  ```shell
  mount /dev/mapper/crypt /mnt/
  mkdir /mnt/@nix
  btrfs subvolume create /mnt/@nix/root
  btrfs subvolume create /mnt/@nix/nix
  btrfs subvolume create /mnt/@nix/var
  btrfs subvolume create /mnt/@nix/home
  btrfs subvolume create /mnt/@nix/home/.snapshots
  btrfs subvolume create /mnt/@nix/data
  umount /mnt
  ```

- Mount volumes

  ```shell
  mount /dev/mapper/crypt -o subvol=@nix/root,noatime,compress=zstd:1 /mnt
  mkdir -p /mnt/{boot/efi,data,etc/luks,home,nix,var}
  mount /dev/disk/by-label/boot /mnt/boot/efi
  mount /dev/mapper/crypt -o subvol=@nix/data,noatime,compress=zstd:1 /mnt/data
  mount /dev/mapper/crypt -o subvol=@nix/home,noatime,compress=zstd:1 /mnt/home
  mount /dev/mapper/crypt -o subvol=@nix/nix,noatime,compress=zstd:1 /mnt/nix
  mount /dev/mapper/crypt -o subvol=@nix/var,noatime,compress=zstd:1 /mnt/var
  ```

- Copy LUKS keyfile (optional)

  ```shell
  cp /etc/luks/boot.keyfile /mnt/etc/luks/
  ```

## Swap

- Create swap file

  ```shell
  truncate -s 0 /mnt/.swapfile
  chattr +C /mnt/.swapfile
  btrfs property set /mnt/.swapfile compression none
  fallocate -l 4G /mnt/.swapfile
  chmod 600 /mnt/.swapfile
  ```

## Installation

- Enter Nix shell

  ```shell
  nix-shell -p git nixos-install-tools
  ```

- Clone repository

  ```shell
  cd /mnt/data
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

- Update inputs

  ```shell
  export NIX_CONFIG="experimental-features = nix-command flakes"
  ./scripts/update.sh
  ```

- Install

  ```shell
  nixos-install --root /mnt --flake /mnt/data/nixos#demo-dual
  ```

- Reboot

## Final steps

- Move configuration to final location

  ```shell
  mkdir -p ~/etc/
  sudo mv /data/nixos ~/etc
  sudo chown user:user -R ~/etc/nixos
  cd ~/etc/nixos
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

- Update and rebuild system

  ```shell
  ./scripts/update.sh
  ./scripts/rebuild.sh demo-dual
  ```
