{ stdenv, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in
stdenv.mkDerivation rec {
  name = "always-indicator";
  src = sources."gse:always-indicator";
  uuid = "always-indicator@martin.zurowietz.de";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r ${uuid}/* $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
