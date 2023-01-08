{ config, lib, pkgs, nixpkgs, ... }:

with lib;
let
  cfg = config.modules.nixos;
  user = config.home.username;
in
{
  options.modules.nixos = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      # nix
      nixpkgs-fmt
      rnix-lsp
    ];

    systemd.user.tmpfiles.rules = [
      "d   %h/.nix-defexpr        0755 ${user} ${user}  -  -"
      "L+  %h/.nix-defexpr/nixos     -       -       -  -  ${nixpkgs}"
    ];
  };
}
