{
  inputs = {
    nixpkgs.url = "/nix/nixpkgs/";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    dotfiles = {
      # url = "github:mrkuz/dotfiles";
      url = "/home/markus/etc/nixos/repos/dotfiles";
      flake = false;
    };
    doomd = {
      # url = "github:mrkuz/doom.d";
      url = "/home/markus/etc/nixos/repos/doom.d";
      flake = false;
    };
    credentials = {
      url = "/home/markus/etc/nixos/credentials.nix";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      setUp = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            _module.args.rev = self.rev or "dirty";
            _module.args.inputs = inputs;
            _module.args.credentials = import inputs.credentials;
            nixpkgs.overlays = [
	      inputs.emacs-overlay.overlay
	      (import ./overlays/nixFlakes.nix)
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
