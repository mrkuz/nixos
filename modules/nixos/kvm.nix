{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.kvm;
in
{
  options.modules.kvm = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kvm
    ];
  };
}
