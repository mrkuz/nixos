{ stdenv, lib, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "instant-workspace-switcher";
  src = sources."gse:instant-workspace-switcher";
  uuid = "instantworkspaceswitcher@amalantony.net";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r ${uuid} $out/share/gnome-shell/extensions/
    runHook postInstall
  '';
}
