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
    dotfiles = {
      # url = "github:mrkuz/dotfiles";
      url = "/home/markus/etc/nixos/repos/dotfiles";
      flake = false;
    };
    credentials = {
      url = "/home/markus/etc/nixos/repos/credentials";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... } @ inputs:
    let
      vars = {
        stateVersion = "22.11";
      };

      attrsToValues = attrs:
        nixpkgs.lib.attrsets.mapAttrsToList (name: value: value) attrs;

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nix-alien.overlay
          inputs.emacs-overlay.overlay
          # inputs.nixpkgs-wayland.overlay
        ] ++ attrsToValues self.overlays;
      };

      mkNixOSModules = name: system: [
        {
          nixpkgs.pkgs = mkPkgs system;
          _module.args.nixpkgs = nixpkgs;
          _module.args.self = self;
          _module.args.inputs = inputs;
          _module.args.credentials = import inputs.credentials;
          _module.args.systemName = name;
          _module.args.vars = vars;
        }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            extraSpecialArgs = { inherit inputs nixpkgs vars; };
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
          }
          {
            home = {
              homeDirectory = "/home/${user}";
              username = user;
            };
          }
          (./users + "/${name}" + /home.nix)
        ];
      };
    in
    {
      nixosConfigurations = {
        "virtualbox" = setUpNixOS "virtualbox" "x86_64-linux";
        "virtualbox-dual" = setUpNixOS "virtualbox-dual" "x86_64-linux";
        "xps15@home" = setUpNixOS "xps15@home" "x86_64-linux";
      };

      homeConfigurations = {
        "markus@ubuntu" = setUpNix "markus@ubuntu" "markus" "x86_64-linux";
        "markus@chromeos" = setUpNix "markus@chromeos" "markus" "aarch64-linux";
      };

      packages = {
        aarch64-linux = {
          # home-manager
          "markus@chromeos" = self.homeConfigurations."markus@chromeos".activationPackage;
        };

        x86_64-linux = {
          # home-manager
          "markus@ubuntu" = self.homeConfigurations."markus@ubuntu".activationPackage;
          # docker
          "docker" = setUpDocker "docker" "x86_64-linux";
          "docker-desktop" = setUpDocker "docker-desktop" "x86_64-linux";
        };
      };

      nixosModules = {
        android = import ./modules/nixos/android.nix;
        avahi = import ./modules/nixos/avahi.nix;
        base-ackages = import ./modules/nixos/base-packages.nix;
        btrfs = import ./modules/nixos/btrfs.nix;
        command-not-found = import ./modules/nixos/command-not-found.nix;
        compatibility = import ./modules/nixos/compatibility.nix;
        desktop = import ./modules/nixos/desktop.nix;
        docker = import ./modules/nixos/docker.nix;
        ecryptfs = import ./modules/nixos/ecryptfs.nix;
        fonts = import ./modules/nixos/fonts.nix;
        gnome = import ./modules/nixos/gnome.nix;
        grub-efi = import ./modules/nixos/grub-efi.nix;
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
        systemd-boot = import ./modules/nixos/systemd-boot.nix;
        virtualbox = import ./modules/nixos/virtualbox.nix;
        waydroid = import ./modules/nixos/waydroid.nix;
        wayland = import ./modules/nixos/wayland.nix;
        x11 = import ./modules/nixos/x11.nix;
      };

      overlays = {
        chromium = import ./overlays/applications/networking/browsers/chromium;
        nix = import ./overlays/tools/package-management/nix;
        gnome-terminal = import ./overlays/desktops/gnome/core/gnome-terminal;
        nautilus = import ./overlays/desktops/gnome/core/nautilus;
      };
    };
}
