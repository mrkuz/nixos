{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.resolved;
in {
  options.modules.resolved = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.resolved.enable = true;
    environment.etc.openvpn.source = "${pkgs.update-systemd-resolved}/libexec/openvpn";

    environment.systemPackages = with pkgs; [
      update-systemd-resolved
    ];
  };
}
