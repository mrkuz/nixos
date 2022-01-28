{ pkgs, lib, ... }:

{
  imports = [
    ../../modules/home-manager/ansible.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/chromium.nix
    ../../modules/home-manager/cloud-packages.nix
    ../../modules/home-manager/conky.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/disable-bluetooth.nix
    ../../modules/home-manager/doom-emacs.nix
    ../../modules/home-manager/emacs.nix
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/hide-applications.nix
    ../../modules/home-manager/java-packages.nix
    ../../modules/home-manager/non-nixos.nix
    ../../modules/home-manager/vscode-profiles.nix
  ];

  modules = {
    hideApplications = {
      enable = true;
      names = [
        "android-file-transfer"
        "calibre-ebook-edit"
        "calibre-ebook-viewer"
        "calibre-lrfviewer"
        "conky"
        "cups"
        "eclipse-mat"
        "emacsclient"
        "fish"
        "hplip"
        "htop"
        "nixos-manual"
        "nvidia-settings"
        "org.gnome.Tour"
        "xpra-gui"
        "xterm"
        "ca.desrt.dconf-editor"
        "software-properties-livepatch"
      ];
    };
  };

  home.activation.channels = lib.hm.dag.entryAfter [ "writeBoundary" ]
    ''
    [ -e $HOME/.nix-defexpr ] || mkdir $HOME/.nix-defexpr
    rm -f $HOME/.nix-defexpr/channels
    touch $HOME/.nix-defexpr/channels
    rm -f $HOME/.nix-defexpr/channels_root
    touch $HOME/.nix-defexpr/channels_root
    [ -e $HOME/.nix-defexpr/nixos ] || ln -svf /nix/channels/nixos $HOME/.nix-defexpr/nixos
    '';
}
