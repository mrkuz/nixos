{ stdenv, glib, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "dash-top-panel";
  src = sources.dash-to-panel;
  uuid = "dash-to-panel@jderose9.github.com";

  buildInputs = [ glib ];
  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];
}
