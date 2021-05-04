{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    sound.enable = true;
    hardware = {
      pulseaudio.enable = true;
      bluetooth.enable = true;
    };

    services = {
      # accounts-daemon.enable = true;
      # bamf.enable = true;
      # colord.enable = true;
      # hardware.bolt.enable
      printing.enable = true;
      # telepathy.enable
      # udisks2.enable = true;
      # upower.enable = true;
      # system-config-printer.enable = true;
      # tumbler.enable = true;
    };

    security.polkit.enable = true;

    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      desktop-file-utils
      shared-mime-info
      xdg-user-dirs
    ];
  };
}
