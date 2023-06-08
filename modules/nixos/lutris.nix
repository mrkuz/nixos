{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.lutris;
in
{
  options.modules.lutris = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      lutris
      mangohud
    ];
  };
}
