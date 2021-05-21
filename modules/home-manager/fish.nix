{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.fish;
in {
  options.modules.fish = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellInit = "test -f ~/.config/fish/config.fish.local && source ~/.config/fish/config.fish.local";
    };
  };
}
