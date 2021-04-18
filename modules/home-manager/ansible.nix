{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.ansible;
in {
  options.modules.ansible = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python38Packages.ansible
      python38Packages.ansible-lint
    ];
  };
}
