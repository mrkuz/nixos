{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    # nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
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

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      vars = {
        stateVersion = "22.05";
        emacs = "emacsPgtkNativeComp";
      };
      setUpNixOS = name: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            _module.args.nixpkgs = nixpkgs;
            _module.args.self = self;
            _module.args.inputs = inputs;
            _module.args.credentials = import inputs.credentials;
            _module.args.configName = name;
            _module.args.vars = vars;
            nixpkgs.overlays = [
              inputs.nix-alien.overlay
              inputs.emacs-overlay.overlay
              # inputs.nixpkgs-wayland.overlay
              (import ./overlays/applications/networking/browsers/chromium)
              (import ./overlays/tools/package-management/nix)
              (import ./overlays/desktops/gnome/core/gnome-terminal)
            ];
          }
          inputs.home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              extraSpecialArgs = { inherit inputs vars; };
            };
          }
          (./hosts + "/${name}" + /configuration.nix)
        ];
      };
      setUpNix = name: user: inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            _module.args.nixpkgs = nixpkgs;
            _module.args.inputs = inputs;
            _module.args.vars = vars;
            nixpkgs.overlays = [
              inputs.emacs-overlay.overlay
              (import ./overlays/tools/package-management/nix)
            ];
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
    in {
      nixosConfigurations."virtualbox" = setUpNixOS "virtualbox";
      nixosConfigurations."xps15@home" = setUpNixOS "xps15@home";
      nixosConfigurations."xps15@work" = setUpNixOS "xps15@work";

      defaultPackage.x86_64-linux = pkgs.nixFlakes;

      homeConfigurations."markus@ubuntu" = setUpNix "markus@ubuntu" "markus";
      packages.x86_64-linux."markus@ubuntu" = self.homeConfigurations."markus@ubuntu".activationPackage;
    };
}
