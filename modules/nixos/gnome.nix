{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.gnome;
in
{
  options.modules.gnome = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.xterm.enable = mkForce false;
      displayManager.defaultSession = "gnome";
    };

    services.gnome = {
      # Disable some core OS services
      # evolution-data-server.enable = mkForce false;
      # gnome-online-accounts.enable = false;
      gnome-online-miners.enable = mkForce false;
      tracker.enable = false;
      tracker-miners.enable = false;
    };

    security.pam.services.gdm.enableGnomeKeyring = true;

    # Requirement for gnome-boxes
    # virtualisation.libvirtd.enable = true;
    # UEFI
    # virtualisation.libvirtd.qemu.ovmf.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome.epiphany
      gnome.geary
      gnome.gnome-clocks
      gnome.gnome-contacts
      gnome.gnome-disk-utility
      gnome.gnome-logs
      gnome.gnome-maps
      gnome.gnome-music
      gnome.gnome-system-monitor
      gnome.totem
      gnome.yelp
      gnome-connections
      gnome-console
      gnome-photos
    ];

    programs.gnome-terminal.enable = true;

    environment.systemPackages = with pkgs; [
      gnome.mutter
      # Gnome utilities
      gnome.dconf-editor
      # gnome.gnome-boxes
      gnome.gnome-tweaks
      gnome.libgnome-keyring
      libnotify
      # Miscellaneous applications
      chromium
      gparted
      gthumb
      remmina
      thunderbird
      vlc
      # Gnome extensions
      # gjs
      gnomeExtensions.appindicator
      gnomeExtensions.window-is-ready-remover
      (callPackage ../../pkgs/desktops/gnome/extensions/always-indicator { })
      (callPackage ../../pkgs/desktops/gnome/extensions/dynamic-panel-transparency { })
      (callPackage ../../pkgs/desktops/gnome/extensions/instant-workspace-switcher { })
      (callPackage ../../pkgs/desktops/gnome/extensions/just-perfection { })
      (callPackage ../../pkgs/desktops/gnome/extensions/workspaces-bar { })
      # Ubuntu look & feel
      yaru-theme
    ];
  };
}
