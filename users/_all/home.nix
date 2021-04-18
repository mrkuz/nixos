{ pkgs, ... }:
{
  imports = [
    ../../modules/home-manager/ansible.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/chromium.nix
    ../../modules/home-manager/cloud-packages.nix
    ../../modules/home-manager/conky.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/doom-emacs.nix
    ../../modules/home-manager/emacs.nix
    ../../modules/home-manager/hide-applications.nix
    ../../modules/home-manager/java-packages.nix
    ../../modules/home-manager/vscode-profiles.nix
  ];

  modules = {
    hideApplications = {
      enable = true;
      names = [
        "android-file-transfer"
        "conky"
        "cups"
        "fish"
        "hplip"
        "htop"
        "nixos-manual"
        "nvidia-settings"
        "xpra-gui"
        "xterm"
        "ca.desrt.dconf-editor"
      ];
    };
  };
}
