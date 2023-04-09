{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };
    dotfiles = {
      # url = "github:mrkuz/dotfiles";
      url = "/home/markus/etc/nixos/repos/dotfiles";
      flake = false;
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      sources = import ./nix/sources.nix // { dotfiles = inputs.dotfiles; };

      vars = {
        currentSystem = "x86_64-linux";
        stateVersion = "22.11";
        ageIdentityFile = "/home/markus/.ssh/id_rsa";
      };

      utils = {
        attrsToValues = attrs:
          nixpkgs.lib.attrsets.mapAttrsToList (name: value: value) attrs;

        mkPkgs = import ./lib/make-pkgs.nix { inherit self nixpkgs inputs; };
        callPkg = package:
          pkgs.callPackage package { inherit sources; };

        mkNixOSModules = import ./lib/make-nixos-modules.nix { inherit self nixpkgs inputs; };
        setUpNixOS = import ./lib/setup-nixos.nix { inherit self nixpkgs inputs; };
        setUpHomeManager = import ./lib/setup-home-manager.nix { inherit self nixpkgs inputs; };
      };

      pkgs = utils.mkPkgs vars.currentSystem;
    in
    {
      inherit sources utils vars;

      nixosConfigurations = {
        "demo" = utils.setUpNixOS {
          name = "demo";
          system = "x86_64-linux";
        };
        "demo-dual" = utils.setUpNixOS {
          name = "demo-dual";
          system = "x86_64-linux";
        };
        "xps15@home" = utils.setUpNixOS {
          name = "xps15@home";
          system = "x86_64-linux";
        };
        "desktop@home" = utils.setUpNixOS {
          name = "desktop@home";
          system = "x86_64-linux";
        };
      };

      homeManagerConfigurations = {
        "user@ubuntu" = utils.setUpHomeManager {
          name = "user@ubuntu";
          user = "markus";
          system = "x86_64-linux";
        };
        "markus@chromeos" = utils.setUpHomeManager {
          name = "markus@chromeos";
          user = "markus";
          system = "aarch64-linux";
        };
      };

      packages = {
        aarch64-linux = {
          # home-manager
          "markus@chromeos" = self.homeManagerConfigurations."markus@chromeos".activationPackage;
        };

        x86_64-linux = {
          # home-manager
          "user@ubuntu" = self.homeManagerConfigurations."user@ubuntu".activationPackage;
          # Docker images
          "dockerized" = (utils.setUpNixOS {
            name = "dockerized";
            system = "x86_64-linux";
          }).config.system.build.dockerTar;
          "dockerized-desktop" = (utils.setUpNixOS {
            name = "dockerized-desktop";
            system = "x86_64-linux";
          }).config.system.build.dockerTar;
          # VMs
          microvm-run = (utils.setUpNixOS {
            name = "microvm";
            system = "x86_64-linux";
          }).config.system.build.qemuRun;
          crosvm-run = (utils.setUpNixOS {
            name = "crosvm";
            system = "x86_64-linux";
          }).config.system.build.crosvmRun;
          lxd-import = (utils.setUpNixOS {
            name = "lxd";
            system = "x86_64-linux";
          }).config.system.build.lxdImport;

          # Packages
          agenix = inputs.agenix.packages.x86_64-linux.default;
          lxd-agent = (utils.callPkg ./pkgs/tools/admin/lxd-agent);
          snapd = (utils.callPkg ./pkgs/tools/package-management/snapd);
          toolbox = (utils.callPkg ./pkgs/applications/virtualization/toolbox);
          # Kernels
          linux-cros = (utils.callPkg ./pkgs/os-specific/linux/kernel/linux-cros);
          # GNOME extensions
          gnome-shell-extensions = {
            always-indicator = (utils.callPkg ./pkgs/desktops/gnome/extensions/always-indicator);
            caffeine = (utils.callPkg ./pkgs/desktops/gnome/extensions/caffeine);
            dynamic-panel-transparency = (utils.callPkg ./pkgs/desktops/gnome/extensions/dynamic-panel-transparency);
            instant-workspace-switcher = (utils.callPkg ./pkgs/desktops/gnome/extensions/instant-workspace-switcher);
            just-perfection = (utils.callPkg ./pkgs/desktops/gnome/extensions/just-perfection);
            space-bar = (utils.callPkg ./pkgs/desktops/gnome/extensions/space-bar);
            quick-settings-tweaks = (utils.callPkg ./pkgs/desktops/gnome/extensions/quick-settings-tweaks);
          };
          # IDEA plugins
          idea-plugins = {
            checkstyle-idea = (utils.callPkg ./pkgs/misc/idea/plugins/checkstyle-idea);
            kotest = (utils.callPkg ./pkgs/misc/idea/plugins/kotest);
            mybatisx = (utils.callPkg ./pkgs/misc/idea/plugins/mybatisx);
          };
          # Helper functions
          buildFhsShell = spec: pkgs.callPackage ./pkgs/shell/build-fhs-shell.nix spec;
          buildShell = spec: pkgs.callPackage ./pkgs/shell/build-shell.nix spec;
          buildVscode = profile: pkgs.callPackage ./pkgs/misc/vscode-extensions/build-vscode.nix profile;
        };
      };

      nixosModules = {
        amdGpu = import ./modules/nixos/amd-gpu.nix;
        android = import ./modules/nixos/android.nix;
        avahi = import ./modules/nixos/avahi.nix;
        basePackages = import ./modules/nixos/base-packages.nix;
        btrfs = import ./modules/nixos/btrfs.nix;
        commandNotFound = import ./modules/nixos/command-not-found.nix;
        compatibility = import ./modules/nixos/compatibility.nix;
        desktop = import ./modules/nixos/desktop.nix;
        docker = import ./modules/nixos/docker.nix;
        ecryptfs = import ./modules/nixos/ecryptfs.nix;
        fonts = import ./modules/nixos/fonts.nix;
        gnome = import ./modules/nixos/gnome.nix;
        grubEfi = import ./modules/nixos/grub-efi.nix;
        homeOverlay = import ./modules/nixos/home-overlay.nix;
        kde = import ./modules/nixos/kde.nix;
        kodi = import ./modules/nixos/kodi.nix;
        kvm = import ./modules/nixos/kvm.nix;
        libreoffice = import ./modules/nixos/libreoffice.nix;
        lxd = import ./modules/nixos/lxd.nix;
        nix = import ./modules/nixos/nix.nix;
        nvidia = import ./modules/nixos/nvidia.nix;
        opengl = import ./modules/nixos/opengl.nix;
        pipewire = import ./modules/nixos/pipewire.nix;
        podman = import ./modules/nixos/podman.nix;
        resolved = import ./modules/nixos/resolved.nix;
        snapd = import ./modules/nixos/snapd.nix;
        snapper = import ./modules/nixos/snapper.nix;
        sshd = import ./modules/nixos/sshd.nix;
        steam = import ./modules/nixos/steam.nix;
        sway = import ./modules/nixos/sway.nix;
        systemdBoot = import ./modules/nixos/systemd-boot.nix;
        tap = import ./modules/nixos/tap.nix;
        toolbox = import ./modules/nixos/toolbox.nix;
        virtualbox = import ./modules/nixos/virtualbox.nix;
        waydroid = import ./modules/nixos/waydroid.nix;
        wayland = import ./modules/nixos/wayland.nix;
        x11 = import ./modules/nixos/x11.nix;
        # Virtualization
        crosvmGuest = import ./modules/nixos/virtualization/crosvm-guest.nix;
        dockerContainer = import ./modules/nixos/virtualization/docker-container.nix;
        lxdContainer = import ./modules/nixos/virtualization/lxd-container.nix;
        qemuGuest = import ./modules/nixos/virtualization/qemu-guest.nix;
      };

      homeManagerModules = {
        bash = import ./modules/home-manager/bash.nix;
        borgBackup = import ./modules/home-manager/borg-backup.nix;
        chromeos = import ./modules/home-manager/chromeos.nix;
        conky = import ./modules/home-manager/conky.nix;
        dconf = import ./modules/home-manager/dconf.nix;
        devShells = import ./modules/home-manager/dev-shells.nix;
        disableBluetooth = import ./modules/home-manager/disable-bluetooth.nix;
        emacs = import ./modules/home-manager/emacs.nix;
        fish = import ./modules/home-manager/fish.nix;
        hideApplications = import ./modules/home-manager/hide-applications.nix;
        idea = import ./modules/home-manager/idea.nix;
        nixos = import ./modules/home-manager/nixos.nix;
        nonNixos = import ./modules/home-manager/non-nixos.nix;
        vscodeProfiles = import ./modules/home-manager/vscode-profiles.nix;
      };

      overlays = {
        chromium = import ./overlays/applications/networking/browsers/chromium;
        gnome-terminal = import ./overlays/desktops/gnome/core/gnome-terminal;
        lxd = import ./overlays/tools/admin/lxd;
        nautilus = import ./overlays/desktops/gnome/core/nautilus;
        nix = import ./overlays/tools/package-management/nix;
        nixos-option = import ./overlays/tools/nix/nixos-option;
      };
    };
}
