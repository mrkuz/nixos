{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.lxd;
in
{
  options.modules.lxd = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    boot.kernelModules = [ "vhost-vsock" ];

    virtualisation.lxd.enable = true;

    environment.systemPackages = with pkgs; [
      virt-viewer
    ];
  };
}
