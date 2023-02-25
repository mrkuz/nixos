{ pkgs, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
{
  imports = [
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/borg-backup.nix
    ../../modules/home-manager/chromeos.nix
    ../../modules/home-manager/chromium.nix
    ../../modules/home-manager/conky.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/dev-shells.nix
    ../../modules/home-manager/disable-bluetooth.nix
    ../../modules/home-manager/emacs.nix
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/hide-applications.nix
    ../../modules/home-manager/idea.nix
    ../../modules/home-manager/nixos.nix
    ../../modules/home-manager/non-nixos.nix
    ../../modules/home-manager/vscode-profiles.nix
  ];

  modules = {
    hideApplications = {
      enable = true;
      names = [
        "android-file-transfer"
        "ca.desrt.dconf-editor"
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
        "scrcpy"
        "scrcpy-console"
        "software-properties-livepatch"
        "Waydroid"
        "xpra-gui"
        "xterm"
      ];
    };
    nixos.enable = true;
  };

  home.activation.hideWaydroidApps = hm.dag.entryAfter [ "writeBoundary" ]
    ''
      sed -i 's/Icon=.*/NoDisplay=true/' ~/.local/share/applications/waydroid*.desktop || true
    '';

  home.stateVersion = vars.stateVersion;
}
