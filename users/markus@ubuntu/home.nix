{ pkgs, inputs, lib, ... }:

{
  imports = [
    (import ../markus/home.nix { inherit pkgs; inherit inputs; })
  ];

  modules = {
    nonNixOs.enable = true;
  };

  home.packages = with pkgs; [
    gitAndTools.gitFull
  ];

  # Gnome extensions
  xdg.dataFile."gnome-shell/extensions/dynamic-panel-transparency@rockon999.github.io".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/dynamic-panel-transparency {}) + "/share/gnome-shell/extensions/dynamic-panel-transparency@rockon999.github.io";
  xdg.dataFile."gnome-shell/extensions/instantworkspaceswitcher@amalantony.net".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/instant-workspace-switcher {}) + "/share/gnome-shell/extensions/instantworkspaceswitcher@amalantony.net";
  xdg.dataFile."gnome-shell/extensions/just-perfection-desktop@just-perfection".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/just-perfection {}) + "/share/gnome-shell/extensions/just-perfection-desktop@just-perfection";
  xdg.dataFile."gnome-shell/extensions/workspaces-bar@fthx".source = (pkgs.callPackage ../../pkgs/desktops/gnome/extensions/workspaces-bar {}) + "/share/gnome-shell/extensions/workspaces-bar@fthx";
}
