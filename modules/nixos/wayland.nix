{ config, lib, pkgs, ... }:

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
      xwayland
    ];
  };
}
