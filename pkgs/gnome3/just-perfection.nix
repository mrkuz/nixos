{ stdenv, glib, ... }:

let
  sources = import ../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "just-perfection";
  src = sources.just-perfection;
  uuid = "just-perfection-desktop@just-perfection";

  buildInputs = [
    glib
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs scripts/
    echo "Compiling schemas..."
    glib-compile-schemas schemas/
    echo "Generating translations..."
    scripts/generate-mo.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r bin lib locale schemas ui *.js *.json *.css $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
