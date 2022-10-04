{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.btrfs;
in
{
  options.modules.btrfs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = [ "btrfs" ];

    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };

    environment.systemPackages = with pkgs; [
      btdu
      btrfs-progs
      compsize
    ];
  };
}
