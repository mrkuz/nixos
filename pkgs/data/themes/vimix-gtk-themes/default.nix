{ stdenv, pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "vimix-gtk-themes";
  src = sources.vimix-gtk-themes;

  buildInputs = [ pkgs.sassc pkgs.which ];
  patches = [ ./ubuntu.patch ];

  dontFixup = true;

  buildPhase = ''
    runHook preBuild
    patchShebangs parse-sass.sh
    ./parse-sass.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    patchShebangs install.sh
    mkdir -p $out/share/themes
    ./install.sh -a -d $out/share/themes
    runHook postInstall
  '';
}
