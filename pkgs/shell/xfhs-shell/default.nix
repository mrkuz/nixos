{ stdenv, pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "xfhs-shell" ''
    export NIX_SHELL="xfhs"
    exec ${pkgs.steam-run}/bin/steam-run ${pkgs.fish}/bin/fish
  '';
in stdenv.mkDerivation rec {
  name = "xfhs-shell";
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script}/bin/xfhs-shell $out/bin/
  '';
}
