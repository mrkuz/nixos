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

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nix-alien.overlay
          inputs.emacs-overlay.overlay
          # inputs.nixpkgs-wayland.overlay
          (import ./overlays/applications/networking/browsers/chromium)
          (import ./overlays/tools/package-management/nix)
          (import ./overlays/desktops/gnome/core/gnome-terminal)
          (import ./overlays/desktops/gnome/core/nautilus)
        ];
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
      ] ++ nixpkgs.lib.attrsets.mapAttrsToList (name: value: value) self.nixosModules;

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
      nixosConfigurations."virtualbox" = setUpNixOS "virtualbox" "x86_64-linux";
      nixosConfigurations."virtualbox-dual" = setUpNixOS "virtualbox-dual" "x86_64-linux";
      nixosConfigurations."xps15@home" = setUpNixOS "xps15@home" "x86_64-linux";

      defaultPackage.x86_64-linux = (mkPkgs "x86_64-linux").nix;

      homeConfigurations."markus@ubuntu" = setUpNix "markus@ubuntu" "markus" "x86_64-linux";
      packages.x86_64-linux."markus@ubuntu" = self.homeConfigurations."markus@ubuntu".activationPackage;

      homeConfigurations."markus@chromeos" = setUpNix "markus@chromeos" "markus" "aarch64-linux";
      packages.aarch64-linux."markus@chromeos" = self.homeConfigurations."markus@chromeos".activationPackage;

      packages.x86_64-linux."docker" = setUpDocker "docker" "x86_64-linux";
      packages.x86_64-linux."docker-desktop" = setUpDocker "docker-desktop" "x86_64-linux";

      nixosModules.android = import ./modules/nixos/android.nix;
      nixosModules.avahi = import ./modules/nixos/avahi.nix;
      nixosModules.base-ackages = import ./modules/nixos/base-packages.nix;
      nixosModules.btrfs = import ./modules/nixos/btrfs.nix;
      nixosModules.command-not-found = import ./modules/nixos/command-not-found.nix;
      nixosModules.compatibility = import ./modules/nixos/compatibility.nix;
      nixosModules.desktop = import ./modules/nixos/desktop.nix;
      nixosModules.docker = import ./modules/nixos/docker.nix;
      nixosModules.ecryptfs = import ./modules/nixos/ecryptfs.nix;
      nixosModules.fonts = import ./modules/nixos/fonts.nix;
      nixosModules.gnome = import ./modules/nixos/gnome.nix;
      nixosModules.grub-efi = import ./modules/nixos/grub-efi.nix;
      nixosModules.kde = import ./modules/nixos/kde.nix;
      nixosModules.kodi = import ./modules/nixos/kodi.nix;
      nixosModules.kvm = import ./modules/nixos/kvm.nix;
      nixosModules.libreoffice = import ./modules/nixos/libreoffice.nix;
      nixosModules.nix = import ./modules/nixos/nix.nix;
      nixosModules.nvidia = import ./modules/nixos/nvidia.nix;
      nixosModules.opengl = import ./modules/nixos/opengl.nix;
      nixosModules.pipewire = import ./modules/nixos/pipewire.nix;
      nixosModules.resolved = import ./modules/nixos/resolved.nix;
      nixosModules.snapper = import ./modules/nixos/snapper.nix;
      nixosModules.sshd = import ./modules/nixos/sshd.nix;
      nixosModules.steam = import ./modules/nixos/steam.nix;
      nixosModules.sway = import ./modules/nixos/sway.nix;
      nixosModules.systemd-boot = import ./modules/nixos/systemd-boot.nix;
      nixosModules.virtualbox = import ./modules/nixos/virtualbox.nix;
      nixosModules.waydroid = import ./modules/nixos/waydroid.nix;
      nixosModules.wayland = import ./modules/nixos/wayland.nix;
      nixosModules.x11 = import ./modules/nixos/x11.nix;

      # packages.x86_64-linux.? = ((mkPkgs "x86_64-linux").callPackage pkgs/? { });
    };
}
