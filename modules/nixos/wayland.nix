{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.wayland;
in
{
  options.modules.wayland = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      waypipe
      xwayland
    ];
  };
}
