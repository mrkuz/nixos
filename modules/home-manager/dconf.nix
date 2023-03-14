{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.dconf;
in
{
  options.modules.dconf = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    iniFile = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    home.activation.dconf = hm.dag.entryAfter [ "installPackages" ]
      ''
        if [[ -v DBUS_SESSION_BUS_ADDRESS ]]; then
          DCONF_DBUS_RUN_SESSION=""
        else
          DCONF_DBUS_RUN_SESSION="${pkgs.dbus}/bin/dbus-run-session"
        fi
        if [[ -v DRY_RUN ]]; then
          echo $DCONF_DBUS_RUN_SESSION ${pkgs.dconf}/bin/dconf load / "<" ${cfg.iniFile}
        else
          $DCONF_DBUS_RUN_SESSION ${pkgs.dconf}/bin/dconf load / < ${cfg.iniFile} || echo "Loading dconf failed"
        fi
        unset DCONF_DBUS_RUN_SESSION
      '';
  };
}
