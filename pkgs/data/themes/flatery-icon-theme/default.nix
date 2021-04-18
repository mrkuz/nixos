{ stdenv, pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "flatery-icon-theme";
  src = sources.flatery-icon-theme;

  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r Flatery* $out/share/icons
    runHook postInstall
  '';
}
