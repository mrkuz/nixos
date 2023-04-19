{
  inputs = {
    mrkuz.url = "github:mrkuz/nixos";
  };
  outputs = { self, mrkuz, nixpkgs }:
    let
      name = "lxd";
      system = "x86_64-linux";
      pkgs = mrkuz.utils.mkPkgs system;
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.profilesPath = "${mrkuz}/profiles";
        modules = mrkuz.utils.mkNixOSModules {
          inherit name system;
          extraModules = [ ./configuration.nix ];
        };
      };
    in
    {
      packages."${system}".default = nixos.config.system.build.lxdImport;
    };
}
