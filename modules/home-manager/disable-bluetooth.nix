{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.disableBluetooth;
in
{
  options.modules.disableBluetooth = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.rfkill = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.util-linux}/bin/rfkill block bluetooth";
      };

      Unit = {
        Description = "Disable bluetooth";
      };
    };
  };
}
