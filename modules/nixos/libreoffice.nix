{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.libreoffice;
in
{
  options.modules.libreoffice = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
      hunspellDicts.de_AT
      hunspellDicts.en_US
    ];
  };
}
