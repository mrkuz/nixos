{ stdenv, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in
stdenv.mkDerivation rec {
  name = "dynamic-panel-transparency";
  src = sources."gse:dynamic-panel-transparency";
  uuid = "dynamic-panel-transparency@rockon999.github.io";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r ${uuid} $out/share/gnome-shell/extensions/
    runHook postInstall
  '';
}
