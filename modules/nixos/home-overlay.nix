{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.homeOverlay;
in
{
  options.modules.homeOverlay = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    directory = mkOption {
      default = "/data/overlays/home";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {

    fileSystems."${cfg.directory}/mnt" = {
      fsType = "overlay";
      device = "overlay";
      options = [
        "lowerdir=/home"
        "upperdir=${cfg.directory}/upper"
        "workdir=${cfg.directory}/work"
        "x-systemd.requires-mounts-for=/home"
      ];
    };
  };
}
