{ stdenv, lib, pkgs, sources, name, targetPkgs, profile ? "", ... }:

pkgs.buildFHSUserEnv {
  name = "${name}-shell";
  targetPkgs = pkgs: targetPkgs;
  profile = ''
    export NIX_SHELL="${name}"
    ${profile}
    exec ${pkgs.fish}/bin/fish
  '';
}
