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
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    security.polkit.enable = true;
    security.rtkit.enable = true;

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      desktop-file-utils
      libnotify
      shared-mime-info
      xdg-user-dirs
    ];
  };
}
