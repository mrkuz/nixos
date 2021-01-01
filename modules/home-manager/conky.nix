{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.conky;
in {
  options.modules.conky = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.conky
    ];

    systemd.user.services.conky = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        ExecStartPre = "/run/current-system/sw/bin/sleep 10";
        ExecStart= "${pkgs.conky}/bin/conky";
        Restart = "on-failure";
      };

      Unit = {
        Description = "Conky system monitor";
        Documentation = "man:conky(1)";
      };
    };
  };
}
