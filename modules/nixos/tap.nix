{ config, lib, pkgs, ... }:

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
    owner = mkOption {
      default = "root";
      type = types.str;
    };
    address = mkOption {
      default = "192.168.77.1";
      type = types.str;
    };
    externalInterface = mkOption {
      default = "eth0";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {

    networking = {
      firewall = {
        trustedInterfaces = [ "tap0" ];
      };

      interfaces = {
        tap0 = {
          virtual = true;
          virtualOwner = cfg.owner;
          ipv4.addresses = [
            {
              address = cfg.address;
              prefixLength = 24;
            }
          ];
        };
      };

      nat = {
        enable = true;
        internalInterfaces = [ "tap0" ];
        externalInterface = cfg.externalInterface;
      };
    };
  };
}
