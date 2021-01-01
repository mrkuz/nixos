{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.hideApplications;
  createDesktopFile = name: {
    name = ".local/share/applications/${name}.desktop";
    value = {
      text = ''
      [Desktop Entry]
      NoDisplay=true
      '';
    };
  };
in {
  options.modules.hideApplications = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    names = mkOption {
      type = types.listOf types.string;
    };
  };

  config = mkIf cfg.enable {
    home.file = listToAttrs (map createDesktopFile cfg.names);
  };
}
