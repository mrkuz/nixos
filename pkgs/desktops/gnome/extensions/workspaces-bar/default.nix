{ stdenv, lib, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "workspaces-bar";
  src = sources."gse:workspaces-bar";
  uuid = "workspaces-bar@fthx";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
