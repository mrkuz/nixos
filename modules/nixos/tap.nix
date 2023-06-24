{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.tap;
in
{
  options.modules.tap = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    name = mkOption {
      default = "tap0";
      type = types.str;
    };
    owner = mkOption {
      default = "root";
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

      interfaces = {
        tap0 = {
          virtual = true;
          virtualOwner = cfg.owner;
          ipv4.addresses = [
            {
              address = cfg.address;
              prefixLength = cfg.prefixLength;
            }
          ];
        };
      };

      nat = {
        enable = true;
        internalInterfaces = [ cfg.name ];
        externalInterface = cfg.externalInterface;
      };
    };
  };
}
