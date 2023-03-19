{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.grubEfi;
in
{
  options.modules.grubEfi = {
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
        canTouchEfiVariables = true;
      };
      grub = {
        device = "nodev";
        efiSupport = true;
      };
      timeout = cfg.timeout;
    };
  };
}
