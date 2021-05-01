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

    hardware.pulseaudio.enable = true;
    hardware.bluetooth.enable = true;

    programs.dconf.enable = true;

    # services.system-config-printer.enable = true;
    services.printing.enable = true;

    # services.accounts-daemon.enable = true;
    # services.bamf.enable = true;
    # services.colord.enable = true;
    security.polkit.enable = true;
    services.smartd.enable = true;
    # services.telepathy.enable
    services.thermald.enable = true;
    # services.udisks2.enable = true;
    # services.upower.enable = true;
    # services.tumbler.enable = true;
  };
}
