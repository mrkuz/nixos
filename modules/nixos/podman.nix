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
      dockerSocket.enable = true;
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
