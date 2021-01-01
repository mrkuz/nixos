{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.avahi;
in {
  options.modules.avahi = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns = true;
    };
  };
}
