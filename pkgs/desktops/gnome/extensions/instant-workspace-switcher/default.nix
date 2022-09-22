{ stdenv, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in
stdenv.mkDerivation rec {
  name = "instant-workspace-switcher";
  src = sources.instant-workspace-switcher;
  uuid = "instantworkspaceswitcher@amalantony.net";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r ${uuid} $out/share/gnome-shell/extensions/
    runHook postInstall
  '';
}
