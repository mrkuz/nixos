{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    # nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
        mkImage = import "${nixpkgs}/nixos/lib/make-disk-image.nix";

        setUpNixOS = import ./lib/setup-nixos.nix { inherit self nixpkgs inputs; };
        setUpHomeManager = import ./lib/setup-home-manager.nix { inherit self nixpkgs inputs; };
      };

      pkgs = utils.mkPkgs vars.currentSystem;
      nixos-generators = inputs.nixos-generators;

      setUpDocker = name: system: nixos-generators.nixosGenerate {
        inherit system;
        modules = utils.mkNixOSModules {
          inherit name system;
          extraModules = [ (./hosts + "/${name}" + /configuration.nix) ];
        };
        format = "docker";
      };

      setUpVm = name: system: nixos-generators.nixosGenerate {
        inherit system;
        modules = utils.mkNixOSModules {
          inherit name system;
          extraModules = [ (./hosts + "/${name}" + /configuration.nix) ];
        };
        format = "vm-nogui";
      };

      setUpKernelInitrd = name: system:
        let
          host = utils.setUpNixOS { inherit name system; };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = utils.mkNixOSModules {
            inherit name system;
            extraModules = [
              {
                boot = {
                  loader.grub.enable = false;
                  kernelPackages = host.config.boot.kernelPackages;
                  initrd = {
                    availableKernelModules = nixpkgs.lib.mkForce host.config.boot.initrd.availableKernelModules;
                    kernelModules = nixpkgs.lib.mkForce host.config.boot.initrd.kernelModules;
                  };
                };
                fileSystems = host.config.fileSystems;
                system.stateVersion = vars.stateVersion;
              }
            ];
          };
        };

      setUpDiskImage = name: system:
        let
          host = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = utils.mkNixOSModules {
              inherit name system;
              extraModules = [
                (./hosts + "/${name}" + /configuration.nix)
                {
                  boot = {
                    initrd.enable = false;
                    kernel.enable = false;
                    loader.grub.enable = false;
                  };
                }
              ];
            };
          };
        in
        utils.mkImage rec {
          pkgs = utils.mkPkgs system;
          lib = pkgs.lib;
          config = host.config;
          installBootLoader = false;
          copyChannel = false;
          additionalSpace = "128M";
          format = "qcow2";
          contents = [
            {
              source = config.system.build.toplevel + "/init";
              target = "/sbin/init";
            }
          ];
        };
    in
    {
      inherit sources utils vars;

      nixosConfigurations = {
        "virtualbox" = utils.setUpNixOS {
          name = "virtualbox";
          system = "x86_64-linux";
        };
        "virtualbox-dual" = utils.setUpNixOS {
          name = "virtualbox-dual";
          system = "x86_64-linux";
        };
        "xps15@home" = utils.setUpNixOS {
          name = "xps15@home";
          system = "x86_64-linux";
        };
        # Docker images
        "dockerized" = utils.setUpNixOS {
          name = "dockerized";
          system = "x86_64-linux";
        };
        "dockerized-desktop" = utils.setUpNixOS {
          name = "dockerized-desktop";
          system = "x86_64-linux";
        };
        # VMs
        "microvm" = utils.setUpNixOS {
          name = "microvm";
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
          dockerized = setUpDocker "dockerized" "x86_64-linux";
          dockerized-desktop = setUpDocker "dockerized-desktop" "x86_64-linux";
          # VMs
          microvm = setUpVm "microvm" "x86_64-linux";
          # Packages
          agenix = inputs.agenix.packages.x86_64-linux.default;
          # Kernels
          linux-cros = (utils.callPkg ./pkgs/os-specific/linux/kernel/linux-cros);
          # crosvm
          crosvm-boot = (setUpKernelInitrd "crosvm" "x86_64-linux").config.system.build.toplevel;
          crosvm-image = setUpDiskImage "crosvm" "x86_64-linux";
          # GNOME extensions
          gnome-shell-extensions = {
            always-indicator = (utils.callPkg ./pkgs/desktops/gnome/extensions/always-indicator);
            dynamic-panel-transparency = (utils.callPkg ./pkgs/desktops/gnome/extensions/dynamic-panel-transparency);
            instant-workspace-switcher = (utils.callPkg ./pkgs/desktops/gnome/extensions/instant-workspace-switcher);
            just-perfection = (utils.callPkg ./pkgs/desktops/gnome/extensions/just-perfection);
            quick-settings-tweaks = (utils.callPkg ./pkgs/desktops/gnome/extensions/quick-settings-tweaks);
            workspaces-bar = (utils.callPkg ./pkgs/desktops/gnome/extensions/workspaces-bar);
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
        kde = import ./modules/nixos/kde.nix;
        kodi = import ./modules/nixos/kodi.nix;
        kvm = import ./modules/nixos/kvm.nix;
        libreoffice = import ./modules/nixos/libreoffice.nix;
        nix = import ./modules/nixos/nix.nix;
        nvidia = import ./modules/nixos/nvidia.nix;
        opengl = import ./modules/nixos/opengl.nix;
        pipewire = import ./modules/nixos/pipewire.nix;
        resolved = import ./modules/nixos/resolved.nix;
        snapper = import ./modules/nixos/snapper.nix;
        sshd = import ./modules/nixos/sshd.nix;
        steam = import ./modules/nixos/steam.nix;
        sway = import ./modules/nixos/sway.nix;
        systemdBoot = import ./modules/nixos/systemd-boot.nix;
        tap = import ./modules/nixos/tap.nix;
        virtualbox = import ./modules/nixos/virtualbox.nix;
        waydroid = import ./modules/nixos/waydroid.nix;
        wayland = import ./modules/nixos/wayland.nix;
        x11 = import ./modules/nixos/x11.nix;
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
        nix = import ./overlays/tools/package-management/nix;
        nixos-option = import ./overlays/tools/nix/nixos-option;
        gnome-terminal = import ./overlays/desktops/gnome/core/gnome-terminal;
        nautilus = import ./overlays/desktops/gnome/core/nautilus;
      };
    };
}
