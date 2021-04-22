{ pkgs, ... }:

pkgs.buildFHSUserEnv {
  name = "fhs-shell";
  targetPkgs = pkgs: [ pkgs.zlib ];
  profile = ''
    export NIX_SHELL="fhs"
  '';
}
