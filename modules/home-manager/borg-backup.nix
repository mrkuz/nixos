{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.borgBackup;
in
{
  options.modules.borgBackup = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      borgbackup
      borgmatic
    ];

    systemd.user.services.borg = {
      Unit = {
        Description = "BorgBackup job";
      };

      Service = {
        ExecStart = "${pkgs.borgmatic}/bin/borgmatic -v 1 --stats init -e none --make-parent-dirs prune compact create check";
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        PrivateTmp = true;
      };
    };

    systemd.user.timers.borg = {
      Unit = {
        Description = "BorgBackup job timer";
      };

      Timer = {
        Unit = "borg.service";
        OnCalendar = "weekly";
        Persistent = true;
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
