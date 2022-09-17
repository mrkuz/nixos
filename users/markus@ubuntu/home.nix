{ pkgs, lib, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in {
  imports = [
    ../markus/home.nix
  ];

  modules = {
    chromium.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    emacs.enable = true;
    nixos.enable = lib.mkForce false;
    nonNixOs.enable = true;
  };

  home.packages = with pkgs; [
    bat
    gitAndTools.gitFull
    htop
  ];

  # Gnome extensions
  xdg.dataFile."gnome-shell/extensions/dynamic-panel-transparency@rockon999.github.io".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/dynamic-panel-transparency {}) + "/share/gnome-shell/extensions/dynamic-panel-transparency@rockon999.github.io";
  xdg.dataFile."gnome-shell/extensions/instantworkspaceswitcher@amalantony.net".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/instant-workspace-switcher {}) + "/share/gnome-shell/extensions/instantworkspaceswitcher@amalantony.net";
  xdg.dataFile."gnome-shell/extensions/just-perfection-desktop@just-perfection".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/just-perfection {}) + "/share/gnome-shell/extensions/just-perfection-desktop@just-perfection";
  xdg.dataFile."gnome-shell/extensions/workspaces-bar@fthx".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/workspaces-bar {}) + "/share/gnome-shell/extensions/workspaces-bar@fthx";
}
