{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.packagekit.enable = true;
    services.upower.enable = true;
    security.polkit.enable = true;
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      desktop-file-utils
      shared-mime-info
      xdg-user-dirs
      xdg-utils
    ];
  };
}
