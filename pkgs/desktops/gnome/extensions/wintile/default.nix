{ stdenv, lib, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "wintile";
  src = sources."gse:wintile";
  uuid = "wintile@nowsci.com";

  buildInputs = with pkgs; [ glib unzip zip ];

  buildPhase = ''
    runHook preBuild
    patchShebangs build.sh
    ./build.sh
    mkdir tmp
    unzip -d tmp -o *.zip
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r tmp/* $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
