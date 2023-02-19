{ stdenv, pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "nixos-option" ''
    ${pkgs.nixos-option}/bin/nixos-option -I nixpkgs=/etc/nixos/compat $@
  '';
in
stdenv.mkDerivation rec {
  name = "nixos-option";
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script}/bin/nixos-option $out/bin/
  '';
}
