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
        buildInputs = with pkgs; [ fish jdk ];
        shellHook = ''
          export NIX_SHELL=jdk-15
          exec fish
        '';
      };
    };
}
