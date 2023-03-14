{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.compatibility;
in
{
  options.modules.compatibility = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      nix-alien
      steam-run
    ];
  };
}
