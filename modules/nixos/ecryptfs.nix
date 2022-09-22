{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.ecryptfs;
in
{
  options.modules.ecryptfs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    security.pam.enableEcryptfs = true;

    environment.systemPackages = with pkgs; [
      ecryptfs
      ecryptfs-helper
    ];
  };
}
