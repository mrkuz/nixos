{ stdenv, pkgs, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "pop-shell";
  src = sources.pop-shell;
  uuid = "pop-shell@system76.com";

  nativeBuildInputs = with pkgs; [ glib nodePackages.typescript ];
  buildInputs = with pkgs; [ gjs ];

  patches = [ ./fix-paths.patch ];
  makeFlags = [
    "INSTALLBASE=$(out)/share/gnome-shell/extensions"
    "PLUGIN_BASE=$(out)/lib/pop-shell/launcher"
    "SCRIPTS_BASE=$(out)/lib/pop-shell/scripts"
  ];

  postInstall = ''
    find $out -name main.js -exec chmod +x {} \;
  '';
}
