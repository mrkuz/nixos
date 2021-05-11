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
    home.packages = with pkgs; [
      # Dependencies
      graphviz
      hugo
      pandoc
      pdftk
      plantuml
      silver-searcher
      texlive.combined.scheme-basic
      (callPackage ../../pkgs/misc/revealjs {})
    ];

    services.emacs = {
      enable = true;
      # package = pkgs.emacsPgtkGcc;
      package = pkgs.emacs;
      client.enable = true;
    };
  };
}
