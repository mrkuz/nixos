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

  home.activation.activate = hm.dag.entryAfter [ "writeBoundary" ]
    ''
    # Create directories
    [ -e $HOME/bin ] || mkdir $HOME/bin
    [ -e $HOME/etc ] || mkdir $HOME/etc
    [ -e $HOME/org ] || mkdir -p $HOME/org/{calendar,lists,mobile,projects}
    [ -e $HOME/tmp ] || mkdir $HOME/tmp
    [ -e $HOME/Games ] || mkdir $HOME/Games
    [ -e $HOME/Notes ] || mkdir $HOME/Notes
    [ -e $HOME/opt ] || mkdir $HOME/opt
    [ -e $HOME/src ] || mkdir $HOME/src
    [ -e $HOME/Workspace ] || mkdir $HOME/Workspace

    # Link some stuff
    [ -e $HOME/etc/dotfiles ] || ln -svf $HOME/etc/nixos/repos/dotfiles $HOME/etc/dotfiles
    [ -e $HOME/etc/emacs.d ] || ln -svf $HOME/etc/nixos/repos/emacs.d $HOME/etc/emacs.d
    [ -e $HOME/.emacs.d ] || ln -svf $HOME/etc/emacs.d $HOME/.emacs.d
    '';

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
