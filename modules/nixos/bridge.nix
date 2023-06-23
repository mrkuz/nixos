{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.bridge;
in
{
  options.modules.bridge = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    name = mkOption {
      default = "br0";
      type = types.str;
    };
    address = mkOption {
      default = "192.168.77.1";
      type = types.str;
    };
    prefixLength = mkOption {
      default = 24;
      type = types.ints.unsigned;
    };
    externalInterface = mkOption {
      default = "eth0";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {

    networking = {
      firewall = {
        trustedInterfaces = [ cfg.name ];
      };

      bridges."${cfg.name}".interfaces = [ ];

      interfaces."${cfg.name}" = {
        ipv4.addresses = [
          {
            address = cfg.address;
            prefixLength = cfg.prefixLength;
          }
        ];
      };

      nat = {
        enable = true;
        internalInterfaces = [ cfg.name ];
        externalInterface = cfg.externalInterface;
      };
    };
  };
}
