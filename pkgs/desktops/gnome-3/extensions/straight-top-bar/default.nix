{ stdenv, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "straight-top-bar";
  src = sources.straight-top-bar;
  uuid = "straighttopbar@peclu.net.net";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r straighttopbar/* $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
