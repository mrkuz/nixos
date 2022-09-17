{ pkgs, lib, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in {
  imports = [
    ../markus/home.nix
  ];

  modules = {
    chromeOs.enable = true;
    nixos.enable = lib.mkForce false;
    nonNixOs.enable = true;
  };

  home.file.".local/share/applications/emacs.desktop".source = "${pkgs.emacs}/share/applications/emacs.desktop";

  home.packages = with pkgs; [
    bat
    emacs
    htop
    ubuntu_font_family
  ];
}
