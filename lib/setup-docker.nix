{ self, nixpkgs, inputs }:

{ name, system }:

(nixpkgs.lib.nixosSystem {
  inherit system;
  modules = self.utils.mkNixOSModules {
    inherit name system;
    extraModules = [
      (import "${nixpkgs}/nixos/modules/virtualisation/docker-image.nix")
      (../hosts + "/${name}" + /configuration.nix)
    ];
  };
}).config.system.build.tarball
