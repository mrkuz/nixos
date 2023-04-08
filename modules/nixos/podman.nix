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
      dockerSocket.enable = config.modules.docker.enable == false;
    };

    virtualisation.containers = {
      enable = true;
      storage.settings = {
        storage = {
          driver = "overlay";
          graphroot = "/var/lib/containers/storage";
          runroot = "/run/containers/storage";
          rootless_storage_path = "/var/lib/containers/storage";
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d   /var/lib/containers/storage  0775  root  podman  -  -"
    ];

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
