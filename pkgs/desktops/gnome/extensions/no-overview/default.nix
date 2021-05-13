{ stdenv, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "no-overview";
  src = sources.no-overview;
  uuid = "no-overview@fthx";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
