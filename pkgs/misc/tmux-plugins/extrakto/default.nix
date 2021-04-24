{ stdenv, pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "extrakto";
  src = sources.extrakto;

  patches = [ ./fix-open.patch ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/tmux-plugins/extrakto/
    cp -r * $out/share/tmux-plugins/extrakto/
    runHook postInstall
  '';
}
