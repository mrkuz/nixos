{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.android;
in
{
  options.modules.android = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      pkgs.android-udev-rules
    ];

    programs.adb.enable = true;
  };
}
