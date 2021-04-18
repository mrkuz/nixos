{ stdenv, pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "yaru-colors-themes";
  src = sources.yaru-colors-themes;

  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r Icons/* $out/share/icons
    mkdir -p $out/share/themes
    cp -r Themes/* $out/share/themes
    runHook postInstall
  '';
}
