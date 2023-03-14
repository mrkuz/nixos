{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.kde;
in
{
  options.modules.kde = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      desktopManager.xterm.enable = mkForce false;
    };
  };
}
