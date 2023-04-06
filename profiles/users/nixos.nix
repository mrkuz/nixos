{ config, lib, pkgs, sources, vars, ... }:

{
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
        "hp-uiscan"
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

  home.stateVersion = vars.stateVersion;
}
