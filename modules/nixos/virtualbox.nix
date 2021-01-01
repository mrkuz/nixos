{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.virtualbox;
in {
  options.modules.virtualbox = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      virtualbox.host.enable = true;
      virtualbox.host.enableExtensionPack = true;
    };

    environment.systemPackages = with pkgs; [
      vagrant
    ];
  };
}
