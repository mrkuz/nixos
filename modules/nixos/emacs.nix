{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.emacs;
in {
  options.modules.emacs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      emacsPgtkGcc
      # emacs
    ];

    fonts.fonts = with pkgs; [
      emacs-all-the-icons-fonts
    ];
  };
}
