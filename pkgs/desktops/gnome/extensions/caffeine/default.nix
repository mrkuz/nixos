{ stdenv, lib, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "caffeine";
  src = sources."gse:caffeine";
  uuid = "caffeine@patapon.info";

  buildInputs = with pkgs; [ gnome.gnome-shell glib unzip ];

  patchPhase = ''
    runHook prePatch
    patchShebangs .
    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r ${uuid} $out/share/gnome-shell/extensions/
    runHook postInstall
  '';
}
