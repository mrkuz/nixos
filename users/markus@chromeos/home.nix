{ pkgs, lib, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
{
  imports = [
    ../markus/home.nix
  ];

  modules = {
    chromeOs.enable = true;
    nixos.enable = lib.mkForce false;
    nonNixOs.enable = true;
  };

  home.packages = with pkgs; [
    bat
    duf
    emacs
    htop
    sqlite
    ubuntu_font_family
  ];
}
