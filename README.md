# Introduction

Welcome to my modular [NixOS](https://nixos.org/) system configuration.

There are three essential components: hosts, users and modules.

A host expression represents a physical or virtual machine. A host has one or more users and imports their configuration.

User configrations are handled by [Home Manager](https://github.com/nix-community/home-manager).

Modules are regular NixOS/Home Manager [modules](https://nixos.wiki/wiki/Module) used by host and user expressions.

## Additions to `/nix`

- `/nix/nixpkgs` - A clone of the [nixpkgs repository](https://github.com/NixOS/nixpkgs)

## Additions to `/etc/nixos`

- `/etc/nixos/compat` - Compatibility layer for non-flake utils
- `/etc/nixos/current` - The active configuration
- `/etc/nixos/nixpkgs` - Link to current NixOS nixpkgs
- `/etc/nixos/options.json` - JSON file of all available NixOS options
- `/etc/nixos/system-packages` - List of installed packages

# Files & directories

## `scripts/`

- `rebuild.sh` - Wrapper for `nixos-rebuild switch`

  _Example_

  ```shell
  ./scripts/rebuild.sh xps15@home
  ```

- `update.sh` - Updates flake inputs, `/nix/nixpkgs` and packages managed by [niv](https://github.com/nmattia/niv.)
- `update-all.sh` - Runs all other update scripts
- `clean-up.sh` - Removes old generations and collects garbage

### VSCode

Scripts to simplify the work with VSCode extensions.

- `add-vscode-extension.sh` - Add VSCode extension to `nix/sources.json`

  _Example_

  ```shell
  ./scripts/add-vscode-extension.sh formulahendry.auto-rename-tag
  ```

- `update-vscode-extensions.sh` - Updates all extensions to the latest version

### IntelliJ IDEA

Scripts to simplify the work with IntelliJ IDEA plugins.

- `add-idea-plugin.sh` - Add IDEA plugin to `nix/sources.json`
- `update-idea-plugins.sh` - Updates all plugins to the latest version

## `profiles`/

### `hosts/`

- `default` - Base configuration for a default host
- `docker` - Base configuration for docker hosts
- `minimal` - Minimal configuration (without nix support)
- `minimal-nix` - Minimal coniguration (with nix support)

## `hosts/`

- `xps15@home` - Configuration for my workstation
- `dockerized` - Dockerized NixOS example
- `dockerized-desktop` - Dockerized NixOS with XFCE desktop
- `virtualbox` - VirtualBox guest example
- `virtualbox` - VirtualBox dual-boot example

## `users/`

- `_all` - Base expression, imported by all other users
- `user` - Example user configuraton
- `user@ubuntu` - Specialization for use within Ubuntu
- `markus` - My base user configuraton
- `markus@home` - Specialization for workstation at home
- ...

## `modules/`

### `nixos/`

- `android` - Support for Android devices
- `avahi` - Configures [avahi](https://www.avahi.org/)
- `base-packages` - Collection of essential CLI tools
- `btrfs` - Configures [btrfs](https://btrfs.wiki.kernel.org/)
- `command-not-found` - Adds simple `command-not-found` script
- `compatibility` - Adds some tools for better compatibility with other Linux distributions
- `desktop` - Essential packages for desktop environments
- `docker` - Adds [Docker](https://www.docker.com/) and utilities
- `ecryptfs` - Support for [eCryptfs](https://www.ecryptfs.org/)
- `fonts` - Adds some fonts
- `gnome` - Configures [Gnome](https://www.gnome.org/) desktop environment
- `grub-efi` - Configures [GRUB](https://www.gnu.org/software/grub/) for UEFI systems
- `kodi` - Adds [Kodi](https://kodi.tv/)
- `kvm` - Support for [KVM](https://www.linux-kvm.org/)
- `libreoffice` - Adds [LibreOffice](https://www.libreoffice.org/)
- `nvidia` -  Configures proprietary NVIDIA drivers
- `nix` - Nix configuration and additions
- `opengl` - Configures [OpenGL](https://www.opengl.org/)
- `pipewire` - Configures [PipeWire](https://pipewire.org/)
- `resolved` - Configures [systemd-resolved](https://www.freedesktop.org/software/systemd/man/systemd-resolved.service.html)
- `snapper` - Configures [Snapper](http://snapper.io/) to create snapshots of `/home` on boot
- `sshd` - Configures [OpenSSH](https://www.openssh.com/) server
- `steam` - Configures [Steam](https://store.steampowered.com/)
- `sway` - Configures [sway](https://github.com/swaywm/sway) window manager
- `systemd-boot` - Configures [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/)
- `virtualbox` - Adds [VirutalBox](https://www.virtualbox.org/) and utilities
- `waydroid` - Adds [Waydroid](hhttps://waydro.id/)
- `wayland` - Adds [Wayland](https://wayland.freedesktop.org/) utilities
- `x11` - Configures X11

### `home-manager/`

- `bash` - Configures [Bash](https://www.gnu.org/software/bash/) shell
- `borg-backup` - Adds job which runs [BorgBackup](https://www.borgbackup.org/)/[borgmatic](https://torsion.org/borgmatic/)
- `chromeos` - Use if [ChromeOS](https://www.google.com/chromebook/chrome-os/)
- `conky` - Configures [conky](https://github.com/brndnmtthws/conky)
- `dconf` - Loads [dconf](https://wiki.gnome.org/Projects/dconf) configuration from file
- `devShells` - Adds custom development shells
- `disable-bluetooth` - Disables Bluetooth on start
- `emacs` - Configures [Emacs](https://www.gnu.org/software/emacs/)
- `fish` - Configures [Fish](https://fishshell.com/) shell
- `hide-applications` - Hides applications from launcher
- `idea` - Adds [IntelliJ IDEA](https://www.jetbrains.com/idea/) with plugins
- `non-nixos` - Use if other Linux OS than NixOS
- `nixos` - NixOS configuration and additions
- `vscode-profiles` - Adds [VSCode](https://code.visualstudio.com/) with multiple profiles

## `overlays/`

Contains some custom [overlays](https://nixos.wiki/wiki/Overlays).

- `application/networking/browsers/chromium` - Chromium with Wayland support
- `desktops/gnome/core/gnome-terminal` - Gnome Terminal with transparency patch
- `desktops/gnome/core/nautilus` - Change grid icon sizes
- `tools/package-management/nix` - Patched to allow downloads from [VSCode Marketplace](https://marketplace.visualstudio.com/vscode)
- `tools/nix/nixos-option` - nixos-option using compatibility layer

## `pkgs/`

Contains a bunch of extra packages.

## `repos/`

These repositories are added as [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

- `emacs.d` - My Emacs [configuration](https://github.com/mrkuz/emacs.d)
- `dotfiles` - My [dotfiles](https://github.com/mrkuz/dotfiles)

## `examples/docker/`

Demonstrates how to build a Docker image from Nix expressions.

```shell
nix build --impure
docker load < result
docker run --rm -ti hello-docker:latest
```

## `examples/jdk15/`

Shows how to create development shells with Nix expressions.

```shell
nix develop
```

# Appendix A: Example NixOS installation (VirtualBox, UEFI, LUKS, BTRFS, systemd-boot)

## Preparation

- Download minimal ISO: https://nixos.org/download.html
- Create virtual machine and boot ISO

## File system

- Create partitions

  ```shell
  parted /dev/sda -- mklabel gpt
  parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
  parted /dev/sda -- set 1 esp on
  parted /dev/sda -- mkpart primary 512MiB 100%
  ```

- Set up LUKS

  ```shell
  cryptsetup luksFormat /dev/sda2
  cryptsetup luksOpen /dev/sda2 crypt
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

  mkfs.fat -F 32 -n boot /dev/sda1
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

## Swap

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
  nixos-install --root /mnt --flake /mnt/data/nixos#virtualbox
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
  ./scripts/rebuild.sh virtualbox
  ```

# Appendix B: Example installation on Ubuntu

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

# Appendix C: Example Ubuntu/NixOS dual boot installation (VirtualBox, UEFI, LUKS, BTRFS, grub2)

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
  nixos-install --root /mnt --flake /mnt/data/nixos#virtualbox-dual
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
  ./scripts/rebuild.sh virtualbox-dual
  ```

# Appendix D: Build and run Docker image

  ```shell
  nix build .#dockerized
  docker import result/tarball/nixos-system-x86_64-linux.tar.xz nixos
  docker run --rm -t --privileged --name nixos --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro nixos /init

  # Other terminal
  docker exec -ti nixos /run/current-system/sw/bin/bash
  ```

# Appendix E: Naming conventions

- File names: kebab-case
- Package names: kebab-case
- Module names: camel-case
- Module options: camel-case
- Functions: kebab-case

# Appendix F: File structures

## Hosts

 1. Imports
 2. Modules
 3. Boot
 4. Filesystems
 5. Networking
 6. Hardware
 7. systemd
 8. Services
 9. Security
10. Virtualization
11. Environment
12. Activation
13. Programs
14. Packages
15. Fonts
16. Users

## NixOS modules

Same as hosts

## Home Manager modules

1. Packages
2. Services
3. Activation
4. Programs

## Users

1. Imports
2. Modules
3. Files
4. Services
5. Activation
6. Programs
7. Packages
