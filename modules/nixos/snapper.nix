{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.snapper;
in
{
  options.modules.snapper = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = config.modules.btrfs.enable;
        message = "snapper depends on module btrfs";
      }
    ];

    services.snapper.configs = {
      home = {
        subvolume = "/home";
        extraConfig = ''
          NUMBER_CLEANUP=yes
          NUMBER_LIMIT=10

          TIMELINE_CREATE=yes
          TIMELINE_CLEANUP=yes

          TIMELINE_LIMIT_HOURLY=12
          TIMELINE_LIMIT_DAILY=0
          TIMELINE_LIMIT_WEEKLY=0
          TIMELINE_LIMIT_MONTHLY=0
          TIMELINE_LIMIT_YEARLY=0
        '';
      };
    };

    systemd.timers.snapper-boot = {
      description = "Take snapper snapshot on boot";
      documentation = [ "man:snapper(8)" "man:snapper-configs(5)" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnBootSec = "1s";
    };

    systemd.services.snapper-boot = {
      description = "Take snapper snapshot on boot";
      documentation = [ "man:snapper(8)" "man:snapper-configs(5)" ];
      serviceConfig = {
        ExecStart = "${pkgs.snapper}/bin/snapper --config home create --cleanup-algorithm number --description boot";
        Type = "oneshot";
      };
      requires = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        ConditionPathExists = "/etc/snapper/configs/home";
      };
    };
  };
}
