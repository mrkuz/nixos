# Example NixOS installation (qemu-kvm, UEFI, LUKS/BTRFS or LVM/ext4, systemd-boot)

## Preparation

- Download minimal ISO: https://nixos.org/download.html
- Create virtual machine and boot ISO

## File system (Variant 1: LUKS/BTRFS)

- Create partitions

  ```shell
  parted /dev/vda -- mklabel gpt
  parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
  parted /dev/vda -- set 1 esp on
  parted /dev/vda -- mkpart primary 512MiB 100%
  ```

- Set up LUKS

  ```shell
  cryptsetup luksFormat /dev/vda2
  cryptsetup luksOpen /dev/vda2 crypt
  ```

- Create filesystems

  ```shell
  mkfs.btrfs -L nixos /dev/mapper/crypt
  mount /dev/disk/by-label/nixos /mnt/
  btrfs subvolume create /mnt/root
  btrfs subvolume create /mnt/nix
  btrfs subvolume create /mnt/var
  btrfs subvolume create /mnt/home
  btrfs subvolume create /mnt/home/.snapshots
  btrfs subvolume create /mnt/data
  umount /mnt

  mkfs.fat -F 32 -n boot /dev/vda1
  ```

- Mount volumes

  ```shell
  mount /dev/disk/by-label/nixos -o subvol=root,noatime,compress=zstd:1 /mnt
  mkdir -p /mnt/{boot,data,home,nix,var}
  mount /dev/disk/by-label/boot /mnt/boot/
  mount /dev/disk/by-label/nixos -o subvol=data,noatime,compress=zstd:1 /mnt/data
  mount /dev/disk/by-label/nixos -o subvol=home,noatime,compress=zstd:1 /mnt/home
  mount /dev/disk/by-label/nixos -o subvol=nix,noatime,compress=zstd:1 /mnt/nix
  mount /dev/disk/by-label/nixos -o subvol=var,noatime,compress=zstd:1 /mnt/var
  ```

- Create swap file

  ```shell
  truncate -s 0 /mnt/.swapfile
  chattr +C /mnt/.swapfile
  btrfs property set /mnt/.swapfile compression none
  fallocate -l 4G /mnt/.swapfile
  chmod 600 /mnt/.swapfile
  ```

- Activate swap
  ```
  mkswap /mnt/.swapfile
  swapon /mnt/.swapfile
  ```

## File system (Variant 2: LVM/ext4)

- Create partitions

  ```shell
  parted /dev/vda -- mklabel gpt
  parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
  parted /dev/vda -- set 1 esp on
  parted /dev/vda -- mkpart primary 512MiB 100%
  parted /dev/vda -- set 2 lvm on
  ```

- Create filesystems

  ```shell
  pvcreate /dev/vda2
  vgcreate pool /dev/vda2

  lvcreate -n host.root -L 1G pool
  lvcreate -n host.var -L 100G pool
  lvcreate -n host.swap -L 4G pool
  lvcreate -n shared.home -L 100G pool
  lvcreate -n shared.data -L 100G pool
  lvcreate -n shared.nix -L 100G pool

  mkfs.fat -F 32 -n boot /dev/vda1
  mkfs.ext4 /dev/pool/host.root
  mkfs.ext4 /dev/pool/host.var
  mkfs.ext4 /dev/pool/shared.home
  mkfs.ext4 /dev/pool/shared.data
  mkfs.ext4 /dev/pool/shared.nix
  ```

- Mount volumes

  ```shell
  mount /dev/pool/host.root /mnt
  mkdir -p /mnt/{boot,data,home,nix,var}
  mount /dev/disk/by-label/boot /mnt/boot/
  mount /dev/pool/host.var /mnt/var
  mount /dev/pool/shared.data /mnt/data
  mount /dev/pool/shared.home /mnt/home
  mount /dev/pool/shared.nix /mnt/nix
  ```

- Activate swap
  ```
  mkswap /dev/pool/host.swap
  swapon /dev/pool/host.swap
  ```

## Installation

- Enter Nix shell

  ```shell
  nix-shell -p git
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
  nixos-install --root /mnt --flake /mnt/data/nixos#demo
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
  ./scripts/rebuild.sh demo
  ```
