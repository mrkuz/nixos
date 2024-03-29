> ⚠️ This configuration is currently not maintained, as I switched to MacOS -> See my nix-darwin [configuration](https://github.com/mrkuz/macos-config).

# Introduction

Welcome to my modular [NixOS](https://nixos.org/) system configuration.

There are four essential building blocks: hosts, users, modules and profiles.

A host expression represents a physical or virtual machine. A host has one or more users and imports their configuration.

User configurations are handled by [Home Manager](https://github.com/nix-community/home-manager).

Modules are regular NixOS/Home Manager [modules](https://nixos.wiki/wiki/Module) used by host and user expressions.

Profiles are reusable snippets used by host and user expressions or modules.

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
- `minimal` - Minimal configuration

### `users/`

- `markus` - Base configuration for my user
- `nixos` - Configuration for NixOS users
- `non-nixos` - Configuration for non-NixOS users

## `hosts/`

- `deskop@home` - Configuration for my workstation
- `xps15@home` - Configuration for my laptop
- `demo` - Example host configuration ([installation guide](./docs/installation-demo.md))
- `demo-dual` - Example dual-boot configuration ([installation guide](./docs/installation-demo-dual.md))

## `users/`

- `user` - Example user configuraton
- `user@ubuntu` - Example user configuraton for Ubuntu ([installation guide](./docs/installation-ubuntu.md))
- `markus@home` - User for my workstation at home
- `markus@chromeos` - User for my Chromebook
- ...

## `modules/`

### `nixos/`

- `amd-gpu` - Support for AMD GPUs
- `android` - Support for Android devices
- `apx` - Adds the [APX package manager](https://documentation.vanillaos.org/docs/apx/)
- `avahi` - Configures [avahi](https://www.avahi.org/)
- `base-packages` - Collection of essential CLI tools
- `btrfs` - Configures [btrfs](https://btrfs.wiki.kernel.org/)
- `command-not-found` - Adds simple `command-not-found` script
- `compatibility` - Adds some tools for better compatibility with other Linux distributions
- `desktop` - Essential packages for [desktop environments](https://www.freedesktop.org/)
- `docker` - Adds [Docker](https://www.docker.com/) and utilities
- `ecryptfs` - Support for [eCryptfs](https://www.ecryptfs.org/)
- `fonts` - Adds some fonts
- `gnome` - Configures [Gnome](https://www.gnome.org/) desktop environment
- `grub-efi` - Configures [GRUB](https://www.gnu.org/software/grub/) for UEFI systems
- `kodi` - Adds [Kodi](https://kodi.tv/)
- `home-overlay` - Creates an overlay for /home
- `libreoffice` - Adds [LibreOffice](https://www.libreoffice.org/)
- `libvirtd` - Support for [libvirtd](https://libvirt.org/)
- `lxd` - Support for [LXD](https://linuxcontainers.org/lxd/)
- `lutris` - Adds [Lutris](https://lutris.net/)
- `nvidia` -  Configures proprietary NVIDIA drivers
- `nix` - Nix configuration and additions
- `opengl` - Configures [OpenGL](https://www.opengl.org/)
- `pipewire` - Configures [PipeWire](https://pipewire.org/)
- `podman` - Adds [Podman](https://podman.io/)
- `resolved` - Configures [systemd-resolved](https://www.freedesktop.org/software/systemd/man/systemd-resolved.service.html)
- `snapd` - Adds [snapd](https://snapcraft.io/docs)
- `snapper` - Configures [Snapper](http://snapper.io/) to create snapshots of `/home` on boot
- `sshd` - Configures [OpenSSH](https://www.openssh.com/) server
- `steam` - Configures [Steam](https://store.steampowered.com/)
- `sway` - Configures [sway](https://github.com/swaywm/sway) window manager
- `systemd-boot` - Configures [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/)
- `tap` - Configures TAP network device
- `toolbox` - Adds [toolbox](https://containertoolbx.org/)
- `virtualbox` - Adds [VirutalBox](https://www.virtualbox.org/) and utilities
- `waydroid` - Adds [Waydroid](https://waydro.id/)
- `wayland` - Adds [Wayland](https://wayland.freedesktop.org/) utilities
- `x11` - Configures X11

### `nixos/virtualization`

- `crosvm-guest` - Prepares host to run [crosvm](https://github.com/google/crosvm) guest
- `docker-container` - Prepares host to run as [Docker](https://www.docker.com/) container
- `lxd-container` - Prepares host to run as [LXD](https://linuxcontainers.org/lxd/) container
- `lxd-vm` - Prepares host to run as [LXD](https://linuxcontainers.org/lxd/) VM
- `qemu-quest` - Prepares host to run [QEMU](https://www.qemu.org/) guest

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
- `waypipe` - Connects host wayland to VM via waypipe, socat and vsocks

## `overlays/`

Contains some custom [overlays](https://nixos.wiki/wiki/Overlays).

- `application/networking/browsers/chromium` - Chromium with Wayland support
- `desktops/gnome/core/gnome-terminal` - Gnome Terminal with transparency patch
- `desktops/gnome/core/nautilus` - Change grid icon sizes
- `tools/package-management/nix` - Patched to allow downloads from [VSCode Marketplace](https://marketplace.visualstudio.com/vscode)
- `tools/admin/lxd` - [LXD](https://linuxcontainers.org/lxd/) with VM support
- `tools/nix/nixos-option` - nixos-option using compatibility layer

## `pkgs/`

Contains a bunch of extra packages.

## `repos/`

These repositories are added as [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

- `emacs.d` - My Emacs [configuration](https://github.com/mrkuz/emacs.d)
- `dotfiles` - My [dotfiles](https://github.com/mrkuz/dotfiles)

## `examples/`

Collection of examples, each with it's own README.

## `docs/`

Documentation and guides.

## `misc/`

Stuff that doesn't fit anywhere else.

# Appendix A: Naming conventions

- File names: kebab-case
- Package names: kebab-case
- Module names: camel-case
- Module options: camel-case
- Functions: kebab-case

# Appendix B: File structures

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
