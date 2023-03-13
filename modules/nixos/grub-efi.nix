{ config, lib, pkgs, ... }:

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
    timeout = mkOption {
      default = 3;
      type = types.ints.unsigned;
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        efiSysMountPoint = "/boot";
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
