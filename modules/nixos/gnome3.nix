{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.gnome3;
in {
  options.modules.gnome3 = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.xterm.enable = mkForce false;
    };

    services.gnome3 = {
      core-os-services.enable = true;
      core-shell.enable = true;
      core-utilities.enable = false;
      chrome-gnome-shell.enable = true;
      gnome-keyring.enable = true;
    };

    security.pam.services.gdm.enableGnomeKeyring = true;

    programs = {
      evince.enable = true;
      file-roller.enable = true;
      gnome-terminal.enable = true;
      seahorse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Gnome core utilities
      baobab
      gnome3.eog
      gnome3.gedit
      gnome3.gnome-calculator
      gnome3.gnome-calendar
      gnome3.gnome-characters
      gnome3.gnome-clocks
      gnome3.gnome-font-viewer
      gnome3.gnome-screenshot
      gnome3.gnome-software
      gnome3.gnome-system-monitor
      gnome3.gnome-weather
      gnome3.nautilus
      simple-scan
      # Gnome utilities
      gnome3.dconf-editor
      gnome3.gnome-tweaks
      gnome3.libgnome-keyring
      # Miscellaneous applications
      chromium
      gimp
      gparted
      remmina
      vlc
      # Gnome extensions
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.dash-to-panel
      gnomeExtensions.impatience
      gnomeExtensions.window-is-ready-remover
      (callPackage ../../pkgs/gnome3/switcher.nix {})
      (callPackage ../../pkgs/gnome3/shortcuts.nix {})
      # Ubuntu look & feel
      yaru-theme
    ];

    # Fonts
    fonts.fonts = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      source-code-pro
      ubuntu_font_family
    ];
  };
}
