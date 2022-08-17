{ pkgs, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in {
  imports = [
    ../../modules/home-manager/ansible.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/chromium.nix
    ../../modules/home-manager/cloud-tools.nix
    ../../modules/home-manager/conky.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/disable-bluetooth.nix
    ../../modules/home-manager/doom-emacs.nix
    ../../modules/home-manager/emacs.nix
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/hide-applications.nix
    ../../modules/home-manager/java-development.nix
    ../../modules/home-manager/nixos.nix
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
    nixos.enable = true;
  };

  home.stateVersion = vars.stateVersion;
}
