{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.toolbox;
in
{
  options.modules.toolbox = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.toolbox ];
    systemd.tmpfiles.packages = [ pkgs.toolbox ];
    virtualisation.podman.enable = true;
  };
}
