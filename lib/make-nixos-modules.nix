{ self, nixpkgs, inputs }:

{ name, system, extraModules ? [ ] }: [
  {
    nixpkgs.pkgs = self.utils.mkPkgs system;
    _module.args.nixpkgs = nixpkgs;
    _module.args.systemName = name;
    _module.args.self = self;
    _module.args.vars = self.vars;
    _module.args.sources = self.sources;
  }
  inputs.agenix.nixosModules.default
  {
    age.identityPaths = [ self.vars.ageIdentityFile ];
  }
  inputs.home-manager.nixosModules.home-manager
  {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = false;
      extraSpecialArgs = {
        inherit nixpkgs;
        inherit (self) vars sources;
      };
      sharedModules = self.utils.attrsToValues self.homeManagerModules;
    };
  }
] ++ self.utils.attrsToValues self.nixosModules ++ extraModules
