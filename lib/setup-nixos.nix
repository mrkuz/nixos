{ self, nixpkgs, inputs }:

{ name, system }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = self.utils.mkNixOSModules {
    inherit name system;
    extraModules = [
      (../hosts + "/${name}" + /configuration.nix)
    ];
  };
}
