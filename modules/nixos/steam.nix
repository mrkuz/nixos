{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.steam;

  empty-cursor = pkgs.writeTextDir "/share/emptyCursor.xbm" ''
    #define emptyCursor_width 1
    #define emptyCursor_height 1
    #define emptyCursor_x_hot 0
    #define emptyCursor_y_hot 0
    static unsigned char emptyCursor_bits[] = {
    0x00};
  '';
in
{
  options.modules.steam = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "Steam";
      start = ''
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor ${empty-cursor}/share/emptyCursor.xbm ${empty-cursor}/share/emptyCursor.xbm
        ${pkgs.steam}/bin/steam -nopipewire -bigpicture -fulldesktopres &
        waitPID=$!
      '';
    }];

    programs.steam.enable = true;
  };
}
