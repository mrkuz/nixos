{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.android;
in {
  options.modules.android = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    services.udev.packages = [
      pkgs.android-udev-rules
    ];

    environment.systemPackages = with pkgs; [
      android-file-transfer
    ];
  };
}
