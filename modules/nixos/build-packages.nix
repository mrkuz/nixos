{ config, lib, pkgs, inputs , ... }:

with lib;
let
  cfg = config.modules.buildPackages;
in {
  options.modules.buildPackages = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      gcc
      gnumake
    ];
  };
}
