# Introduction

Welcome to my modular [NixOS](https://nixos.org/) system configuration.

There are three essential components: hosts, users and modules.

A host expression represents a physical or virtual machine. A host has one or more users and imports their configuration.

User configrations are handled by [Home Manager](https://github.com/nix-community/home-manager).

Modules are regular NixOS/Home Manager [modules](https://nixos.wiki/wiki/Module) used by host and user expressions.

## Additions to `/nix`

- `/nix/nixpkgs` - A clone of the [nixpkgs repository](https://github.com/NixOS/nixpkgs)
- `/nix/current` - The active configuration
- `/nix/channels/nixos` - Local copy of the unstable channel, used as the default Nix expression search path

# Files & directories

## Main directory

### Scripts

- `rebuild.sh` - Wrapper for `nixos-rebuild switch`

  _Example_

  ```shell
  ./rebuild.sh xps15@home
  ```

- `update.sh` - Updates flake inputs, `/nix/nixpkgs` and packages managed by [niv](https://github.com/nmattia/niv.)

- `clean-up.sh` - Removes old generations and collects garbage

### VSCode

Scripts to simplify the work with VSCode extensions.

- `add-vscode-extension.sh` - Creates Nix expression for VSCode extension

  _Example_

  ```shell
  ./add-vscode-extension.sh formulahendry.auto-rename-tag
  ```

- `update-vscode-extensions.sh` - Updates all extensions to the latest version

### Other

- `credentials.nix` - Used to store the passwords for users

  _Example_

  ```nix
  {
    user.password = "password";
    # user.hashedPassword = "..."; # Generated with 'mkpasswd -m sha-512'
  }
  ```

## `hosts/`

- `_all` - Base expression, imported by all other hosts
- `xps15` - Contains common configuration for Dell XPS15
- `xps15@home` - Specialization of xps15 for home
- `xps15@work` - Specialization of xps15 for work
- `virtualbox` - Configuration for VirtualBox

## `users/`

- `_all` - Base expression, imported by all other users
- `markus` - My base user configuraton
- `markus@home` - Specialization for home
- `markus@work` - Specialization for work

## `modules/`

### `nixos/`

- `android` - Support for Android devices
- `avahi` - Configures [avahi](https://www.avahi.org/)
- `base-packages` - Collection of essential CLI tools
- `btrfs` - Configures [btrfs](https://btrfs.wiki.kernel.org/)
- `build-packages` - Build essentials
- `command-not-found` - Adds simple `command-not-found` script
- `compatibility` - Adds `fhs-shell`, a FHS-compatible shell
- `desktop` - Essential packages for desktop environments
- `docker` - Adds [Docker](https://www.docker.com/) and utilities
- `ecryptfs` - Support for [eCryptfs](https://www.ecryptfs.org/)
- `emacs` - Adds [Emacs](https://www.gnu.org/software/emacs/)
- `gnome` - Configures [Gnome](https://www.gnome.org/) desktop environment
- `grub-efi` - Configures [GRUB](https://www.gnu.org/software/grub/) for UEFI systems
- `kodi` - Adds [Kodi](https://kodi.tv/)
- `kvm` - Support for [KVM](https://www.linux-kvm.org/)
- `libreoffice` - Adds [LibreOffice](https://www.libreoffice.org/)
- `nvidia` -  Configures proprietary NVIDIA drivers
- `opengl` - Configures [OpenGL](https://www.opengl.org/)
- `pipewire` - Configures [PipeWire](https://pipewire.org/)
- `resolved` - Configures [systemd-resolved](https://www.freedesktop.org/software/systemd/man/systemd-resolved.service.html)
- `sshd` - Configures [OpenSSH](https://www.openssh.com/) server
- `sway` - Configures [sway](https://github.com/swaywm/sway) window manager
- `systemd-boot` - Configures [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/)
- `virtualbox` - Adds [VirutalBox](https://www.virtualbox.org/) and utilities
- `wayland` - Adds [Wayland](https://wayland.freedesktop.org/) utilities
- `x11` - Configures X11

### `home-manager/`

- `ansible` - Adds [Ansible](https://www.ansible.com/)
- `bash` - Configures [Bash](https://www.gnu.org/software/bash/) shell
- `chromium` - Configures [Chromium](https://www.chromium.org/) web browser and extensions
- `cloud-packages` - [Kubernetes](https://kubernetes.io/) and Google Cloud related packages
- `conky` - Configures [conky](https://github.com/brndnmtthws/conky)
- `dconf` - Loads [dconf](https://wiki.gnome.org/Projects/dconf) configuration from file
- `disable-bluetooth` - Disables Bluetooth on start
- `doom-emacs` - Configures [Doom Emacs](https://github.com/hlissner/doom-emacs)
- `emacs` - Configures [Emacs](https://www.gnu.org/software/emacs/)
- `fish` - Configures [Fish](https://fishshell.com/) shell
- `hide-applications` - Hides applications from launcher
- `java-packages` - [Java](https://www.java.com/en/) development related packages
- `vscode-profiles` - Adds [VSCod](https://code.visualstudio.com/) with multiple profiles

## `overlays/`

Contains some custom [overlays](https://nixos.wiki/wiki/Overlays).

- `application/networking/browsers/chromium` - Chromium with Wayland support
- `desktops/gnome/core/gnome-shell` - OBSOLETE
- `desktops/gnome/core/gnome-terminal` - Gnome Terminal with transparency patch
- `desktops/gnome/core/mutter` - OBSOLETE
- `tools/package-management/nix` - Patched to allow relative inputs and downloads from [VSCode Marketplace](https://marketplace.visualstudio.com/vscode)

## `pkgs/`

Contains a bunch of extra packages.

## `repos/`

Other repostories used, added as [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

- `doom.d` - My Doom Emacs [configuration](https://github.com/mrkuz/doom.d)
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

# Appendix A: Example installation (VirtualBox)

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

- Create filesystems

  ```shell
  mkfs.btrfs -L nixos /dev/sda2
  mount /dev/disk/by-label/nixos /mnt/
  btrfs subvolume create /mnt/root
  btrfs subvolume create /mnt/nix
  btrfs subvolume create /mnt/var
  btrfs subvolume create /mnt/home
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
  nix-shell -p git nixUnstable
  ```

- Clone repository

  ```shell
  cd /mnt/data
  git clone https://github.com/mrkuz/nixos.git
  cd nixos
  ```

- Change `dotfiles.url` and `doomd.url` in `flake.nix` to point to GitHub repositories, not local directories.

  ```nix
  {
    dotfiles = {
      url = "github:mrkuz/dotfiles";
      flake = false;
    };
    doomd = {
      url = "github:mrkuz/doom.d";
      flake = false;
    };
  }
  ```

- Create `credentials.nix` and set password for the user `user`.

  ```nix
  {
    user.password = "...";
    # user.hashedPassword = "..."; # Generated with 'mkpasswd -m sha-512'sha-512'
  }
  ```

- Update `credentials.url` in `flake.nix`. Must be an absolute path.

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

- Replace `dotfiles.url`, `doomd.url` and `credentials.url` in `flake.nix` with relative paths.

  ```nix
  {
    dotfiles = {
      url = "./repos/dotfiles";
      flake = false;
    };
    doomd = {
      url = "./repos/doom.d";
      flake = false;
    };
    credentials = {
      url = "./credentials.nix";
      flake = false;
    };
  }
  ```

- Update and rebuild system

  ```shell
  ./update.sh
  ./rebuild.sh virtualbox
  ```

# Appendix B: File structures

## Hosts

 1. Imports
 2. Modules
 3. Boot
 4. Networking
 5. Filesystems
 6. Hardware
 7. systemd
 8. Services
 9. Security
10. Virtualization
11. Environment
12. Activation
13. Packages
14. Fonts
15. Users

## NixOS modules

Same as hosts

## Home Manager modules

1. Packages
2. Services
3. Activation

## Users

1. Imports
2. Modules
3. Files
4. Services
5. Activation
6. Packages
