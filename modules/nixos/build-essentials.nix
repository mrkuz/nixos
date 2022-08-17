{ config, lib, pkgs, inputs , ... }:

with lib;
let
  cfg = config.modules.buildEssentials;
in {
  options.modules.buildEssentials = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      cmake
      gcc
      gnumake
    ];
  };
}
