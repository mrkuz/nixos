{ config, lib, pkgs, vars, ... }:

with lib;
let
  cfg = config.modules.emacs;
  emacsPkg = (getAttr vars.emacs pkgs);
in
{
  options.modules.emacs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ ((pkgs.emacsPackagesFor emacsPkg).emacsWithPackages (epkgs: [ epkgs.vterm ])) ];

    fonts.fonts = with pkgs; [
      emacs-all-the-icons-fonts
    ];
  };
}
