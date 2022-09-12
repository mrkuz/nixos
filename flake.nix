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

  outputs = { self, nixpkgs, nixos-generators, ... } @ inputs:
    let
      vars = {
        stateVersion = "22.05";
        emacs = "emacsPgtkNativeComp";
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
        ];
      };
      setUpNixOS = name: system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            nixpkgs.pkgs = mkPkgs system;
            _module.args.nixpkgs = nixpkgs;
            _module.args.self = self;
            _module.args.inputs = inputs;
            _module.args.credentials = import inputs.credentials;
            _module.args.configName = name;
            _module.args.vars = vars;
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
    in {
      nixosConfigurations."virtualbox" = setUpNixOS "virtualbox" "x86_64-linux";
      nixosConfigurations."xps15@home" = setUpNixOS "xps15@home" "x86_64-linux";
      nixosConfigurations."xps15@work" = setUpNixOS "xps15@work" "x86_64-linux";

      defaultPackage.x86_64-linux = (mkPkgs "x86_64-linux").nixFlakes;

      homeConfigurations."markus@ubuntu" = setUpNix "markus@ubuntu" "markus" "x86_64-linux";
      packages.x86_64-linux."markus@ubuntu" = self.homeConfigurations."markus@ubuntu".activationPackage;#

      homeConfigurations."markus@chromeos" = setUpNix "markus@chromeos" "markus" "aarch64-linux";
      packages.aarch64-linux."markus@chromeos" = self.homeConfigurations."markus@chromeos".activationPackage;
    };
}
