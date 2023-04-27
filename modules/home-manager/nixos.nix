{ config, lib, pkgs, sources, vars, nixpkgs, ... }:

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
      niv
      nix-index
      nix-index-update
      nixpkgs-fmt
      rnix-lsp
    ];

    home.file.".nix".text = ''
      system.stateVersion = "${vars.stateVersion}";
      system.configurationRevision = "${vars.rev}";
    '';

    systemd.user.tmpfiles.rules = [
      "d   %h/.nix-defexpr        0755 ${user} ${user}  -  -"
      "L+  %h/.nix-defexpr/nixos     -       -       -  -  ${nixpkgs}"
      "L+  %h/.nix-defexpr/nixpkgs   -       -       -  -  ${nixpkgs}"
    ];
  };
}
