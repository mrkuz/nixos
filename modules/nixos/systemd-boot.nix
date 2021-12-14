{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.systemdBoot;
in {
  options.modules.systemdBoot = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = false;
      };
      systemd-boot = {
        enable = true;
        editor = true;
        configurationLimit = 10;
      };
      timeout = 3;
    };
  };
}
