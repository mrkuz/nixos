{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.podman;
in
{
  options.modules.podman = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "daily";
      };
      # dockerCompat.enable = config.modules.docker.enable == false;
      dockerSocket.enable = config.modules.docker.enable == false;
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
