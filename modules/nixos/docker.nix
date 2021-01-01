{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.docker;
in {
  options.modules.docker = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = true;
    };

    environment.systemPackages = with pkgs; [
      docker-compose
      x11docker
    ];
  };
}
