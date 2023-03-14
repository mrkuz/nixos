{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.sshd;
in
{
  options.modules.sshd = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    port = mkOption {
      default = 9999;
      type = types.ints.unsigned;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      ports = [ cfg.port ];
      settings.PermitRootLogin = "no";
    };
  };
}
