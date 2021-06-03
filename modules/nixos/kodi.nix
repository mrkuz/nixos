{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.kodi;
in {
  options.modules.kodi = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (pkgs.kodi.withPackages (p: with p; [
        inputstream-adaptive
      ]))
    ];
  };
}
