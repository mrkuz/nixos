{ stdenv, pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "vimix-icon-theme";
  src = sources.vimix-icon-theme;

  nativeBuildInputs = [ pkgs.gtk3 ];
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    patchShebangs .
    mkdir -p $out/share/icons
    ./install.sh -a -d $out/share/icons
    runHook postInstall
  '';
}
