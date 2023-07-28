{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    fonts.enableDefaultPackages = true;
    fonts.fonts = with pkgs; [
      cantarell-fonts
      dejavu_fonts
      fira-code
      fira-code-symbols
      inconsolata
      liberation_ttf
      # google-fonts
      helvetica-neue-lt-std
      jetbrains-mono
      # mplus-outline-fonts
      # noto-fonts
      roboto
      roboto-mono
      source-code-pro
      source-sans-pro
      ubuntu_font_family
    ];
  };
}
