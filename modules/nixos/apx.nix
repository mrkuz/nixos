{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.apx;
in
{
  options.modules.apx = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    environment.etc."apx/config.json".text = ''
      {
        "containername": "apx_managed",
        "image": "docker.io/library/ubuntu",
        "pkgmanager": "apt",
        "distroboxpath": "${pkgs.distrobox}/bin/distrobox"
      }
    '';

    environment.systemPackages = with pkgs; [
      apx
      distrobox
    ];
  };
}
