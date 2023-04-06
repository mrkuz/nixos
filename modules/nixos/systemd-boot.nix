{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.systemdBoot;
in
{
  options.modules.systemdBoot = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    mountPoint = mkOption {
      default = "/boot";
      type = types.str;
    };
    timeout = mkOption {
      default = 3;
      type = types.ints.unsigned;
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        efiSysMountPoint = cfg.mountPoint;
        canTouchEfiVariables = false;
      };
      systemd-boot = {
        enable = true;
        editor = true;
        configurationLimit = 3;
        consoleMode = "max";
      };
      timeout = cfg.timeout;
    };
  };
}
