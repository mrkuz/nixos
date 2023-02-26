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

  outputs = { self, nixpkgs, nixos-generators, agenix, ... } @ inputs:
    let
      vars = {
        currentSystem = "x86_64-linux";
        stateVersion = "22.11";
        ageIdentityFile = "/home/markus/.ssh/id_rsa";
      };
      sources = import ./nix/sources.nix;

      attrsToValues = attrs:
        nixpkgs.lib.attrsets.mapAttrsToList (name: value: value) attrs;

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nix-alien.overlay
          inputs.emacs-overlay.overlay
          # inputs.nixpkgs-wayland.overlay
          (_: super: self.packages."${system}")
        ] ++ attrsToValues self.overlays;
      };

      pkgs = mkPkgs vars.currentSystem;
      callPkg = package:
        pkgs.callPackage package { inherit sources; };

      mkNixOSModules = name: system: [
        {
          nixpkgs.pkgs = mkPkgs system;
          _module.args.nixpkgs = nixpkgs;
          _module.args.self = self;
          _module.args.inputs = inputs;
          _module.args.systemName = name;
          _module.args.vars = vars;
          _module.args.sources = sources;
        }
        agenix.nixosModules.default
        {
          age.identityPaths = [ vars.ageIdentityFile ];
        }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            extraSpecialArgs = { inherit inputs nixpkgs vars sources; };
            sharedModules = attrsToValues self.homeManagerModules;
          };
        }
        (./hosts + "/${name}" + /configuration.nix)
      ] ++ attrsToValues self.nixosModules;

      setUpNixOS = name: system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = mkNixOSModules name system;
      };

      setUpDocker = name: system: nixos-generators.nixosGenerate {
        inherit system;
        modules = mkNixOSModules name system;
        format = "docker";
      };

      setUpNix = name: user: system: inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs system;
        modules = [
          {
            _module.args.nixpkgs = nixpkgs;
            _module.args.inputs = inputs;
            _module.args.vars = vars;
            _module.args.sources = sources;
          }
          {
            home = {
              homeDirectory = "/home/${user}";
              username = user;
            };
          }
          (./users + "/${name}" + /home.nix)
        ] ++ attrsToValues self.homeManagerModules;
      };
    in
    {
      nixosConfigurations = {
        "virtualbox" = setUpNixOS "virtualbox" "x86_64-linux";
        "virtualbox-dual" = setUpNixOS "virtualbox-dual" "x86_64-linux";
        "xps15@home" = setUpNixOS "xps15@home" "x86_64-linux";
      };

      homeManagerConfigurations = {
        "markus@ubuntu" = setUpNix "markus@ubuntu" "markus" "x86_64-linux";
        "markus@chromeos" = setUpNix "markus@chromeos" "markus" "aarch64-linux";
      };

      packages = {
        aarch64-linux = {
          # home-manager
          "markus@chromeos" = self.homeManagerConfigurations."markus@chromeos".activationPackage;
        };

        x86_64-linux = {
          # home-manager
          "markus@ubuntu" = self.homeManagerConfigurations."markus@ubuntu".activationPackage;
          # Docker images
          docker-images = {
            docker = setUpDocker "docker" "x86_64-linux";
            docker-desktop = setUpDocker "docker-desktop" "x86_64-linux";
          };
          agenix = agenix.packages.x86_64-linux.default;
          # GNOME extensions
          gnome-shell-extensions = {
            always-indicator = (callPkg ./pkgs/desktops/gnome/extensions/always-indicator);
            dynamic-panel-transparency = (callPkg ./pkgs/desktops/gnome/extensions/dynamic-panel-transparency);
            instant-workspace-switcher = (callPkg ./pkgs/desktops/gnome/extensions/instant-workspace-switcher);
            just-perfection = (callPkg ./pkgs/desktops/gnome/extensions/just-perfection);
            quick-settings-tweaks = (callPkg ./pkgs/desktops/gnome/extensions/quick-settings-tweaks);
            workspaces-bar = (callPkg ./pkgs/desktops/gnome/extensions/workspaces-bar);
          };
          # IDEA plugins
          idea-plugins = {
            checkstyle-idea = (callPkg ./pkgs/misc/idea/plugins/checkstyle-idea);
            kotest = (callPkg ./pkgs/misc/idea/plugins/kotest);
            mybatisx = (callPkg ./pkgs/misc/idea/plugins/mybatisx);
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
