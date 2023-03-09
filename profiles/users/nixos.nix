{ pkgs, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
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
