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
    dotfiles = {
      # url = "github:mrkuz/dotfiles";
      url = "./repos/dotfiles";
      flake = false;
    };
    doomd = {
      # url = "github:mrkuz/doom.d";
      url = "./repos/doom.d";
      flake = false;
    };
    credentials = {
      url = "./credentials.nix";
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
      setUp = name: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            _module.args.nixpkgs = nixpkgs;
            _module.args.self = self;
            _module.args.inputs = inputs;
            _module.args.credentials = import inputs.credentials;
            _module.args.pkgs-local = pkgs-local;
            _module.args.pkgs-stable = pkgs-stable;
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
    in {
      nixosConfigurations."virtualbox" = setUp "virtualbox";
      nixosConfigurations."xps15@home" = setUp "xps15@home";
      nixosConfigurations."xps15@work" = setUp "xps15@work";

      defaultPackage.x86_64-linux = pkgs.nixFlakes;
    };
}
