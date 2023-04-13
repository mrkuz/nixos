{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.x11;
in
{
  options.modules.x11 = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.xterm.enable = true;
      libinput.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xclip
      xorg.xhost
      xorg.xkill
      xpra
    ];
  };
}
