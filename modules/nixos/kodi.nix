{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.kodi;
in {
  options.modules.kodi = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.kodi.enableInputStreamAdaptive = true;

    environment.systemPackages = with pkgs; [
      kodi
    ];
  };
}
