{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      devShell."${system}" = pkgs.mkShell {
        buildInputs = with pkgs; [ fish phoronix-test-suite zlib mpi autoconf popt libaio python2 ];
        shellHook = ''
          export NIX_SHELL=pts
          exec fish
        '';
      };
    };
}
