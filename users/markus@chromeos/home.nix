{ pkgs, lib, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
{
  imports = [
    ../../profiles/users/non-nixos.nix
    ../../profiles/users/markus.nix
  ];

  modules = {
    chromeOs.enable = true;
  };

  services.syncthing = {
    enable = true;
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
