{ stdenv, ... }:

let
  sources = import ../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "gnome-shell-switcher";
  src = sources.switcher;
  uuid = "switcher@landau.fi";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
