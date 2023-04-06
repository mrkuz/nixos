{ stdenv, lib, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "space-bar";
  src = sources."gse:space-bar";
  uuid = "space-bar@luchrioh";

  buildInputs = with pkgs; [
    glib
    gnome.gnome-shell
    nodePackages.typescript
    unzip
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs scripts/
    ./scripts/build.sh
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
