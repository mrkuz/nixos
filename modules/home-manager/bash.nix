{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.bash;
in
{
  options.modules.bash = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      initExtra = "[ -e ~/.bashrc.local ] && source ~/.bashrc.local";
    };
  };
}
