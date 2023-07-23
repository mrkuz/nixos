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

    boot.kernelModules = [ "vhost-vsock" "dm-snapshot" "dm-thin-pool" ];
    networking.firewall.trustedInterfaces = [ "lxdbr0" ];

    virtualisation.lxd = {
      enable = true;
      ui.enable = true;
    };

    environment.systemPackages = with pkgs; [
      virt-viewer
    ];

    systemd.services.lxd-ui = {
      description = "Enable LXD UI";
      serviceConfig = {
        ExecStart = "${pkgs.lxd}/bin/lxc config set core.https_address localhost:8443";
        Type = "oneshot";
      };
      after = [ "lxd.service" ];
      wantedBy = [ "multi-user.target" ];
    };

  };
}
