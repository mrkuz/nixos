{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-21.05";
    nixpkgs-local.url = "/nix/nixpkgs/";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    dotfiles = {
      # url = "github:mrkuz/dotfiles";
      url = "/home/markus/etc/nixos/repos/dotfiles";
      flake = false;
    };
    emacsd = {
      # url = "github:mrkuz/emacs.d";
      url = "/home/markus/etc/nixos/repos/emacs.d";
      flake = false;
    };
    credentials = {
      url = "/home/markus/etc/nixos/repos/credentials";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-local, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-local = import nixpkgs-local {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-stable = import nixpkgs-local {
        inherit system;
        config.allowUnfree = true;
      };
      setUpNixOS = name: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            _module.args.nixpkgs = nixpkgs;
            _module.args.self = self;
            _module.args.inputs = inputs;
            _module.args.credentials = import inputs.credentials;
            _module.args.pkgs-local = pkgs-local;
            _module.args.pkgs-stable = pkgs-stable;
            _module.args.config-name = name;
            nixpkgs.overlays = [
              inputs.emacs-overlay.overlay
              # inputs.nixpkgs-wayland.overlay
              (import ./overlays/applications/networking/browsers/chromium)
              (import ./overlays/tools/package-management/nix)
              (import ./overlays/desktops/gnome/core/gnome-terminal)
            ];
          }
          inputs.home-manager.nixosModules.home-manager
          (./hosts + "/${name}" + /configuration.nix)
        ];
      };
      setUpNix = name: user: inputs.home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        homeDirectory = "/home/${user}";
        username = user;
        configuration = {
          nixpkgs.overlays = [
            inputs.emacs-overlay.overlay
            (import ./overlays/tools/package-management/nix)
          ];
          imports = [
            {
              _module.args.nixpkgs = nixpkgs;
              _module.args.inputs = inputs;
            }
            (./users + "/${name}" + /home.nix)
          ];
        };
      };
    in {
      nixosConfigurations."virtualbox" = setUpNixOS "virtualbox";
      nixosConfigurations."xps15@home" = setUpNixOS "xps15@home";
      nixosConfigurations."xps15@work" = setUpNixOS "xps15@work";

      defaultPackage.x86_64-linux = pkgs.nixFlakes;

      homeConfigurations."markus@ubuntu" = setUpNix "markus@ubuntu" "markus";
      packages.x86_64-linux."markus@ubuntu" = self.homeConfigurations."markus@ubuntu".activationPackage;
    };
}
