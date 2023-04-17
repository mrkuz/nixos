{
  inputs = {
    mrkuz.url = "github:mrkuz/nixos";
  };
  outputs = { self, mrkuz, nixpkgs }:
    let
      profile = "java";
      system = "x86_64-linux";
      pkgs = mrkuz.utils.mkPkgs system;
      mkSpec = import "${mrkuz}/profiles/dev-shells/${profile}.nix";
      spec = (mkSpec { inherit pkgs; }) // { inherit (mrkuz) sources; };
    in
    {
      packages."${system}".default = mrkuz.packages."${system}".buildShell spec;
    };
}
