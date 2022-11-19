{ stdenv, pkgs, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in
stdenv.mkDerivation rec {
  name = "quick-settings-tweaks";
  src = sources."gse:quick-settings-tweaks";
  uuid = "quick-settings-tweaks@qwreey";

  buildInputs = with pkgs; [ gnome.gnome-shell glib unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    unzip -o dist/*.zip -d $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
