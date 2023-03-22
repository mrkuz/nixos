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
        buildInputs = with pkgs; [
          fish
          phoronix-test-suite
          autoconf
          freeglut
          libaio
          libjpeg
          libpng
          mpi
          pkg-config
          popt
          python2
          waf
          xorg.libX11
          zlib
        ];
        shellHook = ''
          export NIX_SHELL=pts
          exec fish
        '';
      };
    };
}
