{ self, nixpkgs, inputs }:

{ name, system }: nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs.profilesPath = "${self}/profiles";
  modules = self.utils.mkNixOSModules {
    inherit name system;
    extraModules = [
      (../hosts + "/${name}" + /configuration.nix)
    ];
  };
}
