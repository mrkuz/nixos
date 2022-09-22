{ stdenv, pkgs, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in
stdenv.mkDerivation rec {
  name = "just-perfection";
  src = sources.just-perfection;
  uuid = "just-perfection-desktop@just-perfection";

  buildInputs = with pkgs; [ gnome.gnome-shell glib unzip ];

  buildPhase = ''
    runHook preBuild
    patchShebangs scripts/
    scripts/build.sh
    unzip -o *.zip
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r bin lib locale schemas ui *.js *.json *.css $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
