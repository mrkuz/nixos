{
  inputs = {
    nixpkgs.url = "path:/nix/channels/nixos";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      defaultPackage."${system}" = pkgs.dockerTools.buildImage {
        name = "hello-docker";
        tag = "latest";
        contents = with pkgs; [ bash coreutils findutils which ];
        config = {
          Cmd = [ "${pkgs.bash}/bin/bash" ];
        };
      };
    };
}
