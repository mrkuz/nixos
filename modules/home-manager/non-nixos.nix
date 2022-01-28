{ config, lib, pkgs, nixpkgs, ... }:

with lib;
let
  cfg = config.modules.nonNixOs;
in {
  options.modules.nonNixOs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # nix
      niv
      nixFlakes
      # base-packages
      fzf
      tmux
    ];

    targets.genericLinux.enable = true;

    home.file.".config/nix/nix.conf".text = ''
      experimental-features = nix-command flakes
      substituters = https://cache.nixos.org https://nix-community.cachix.org
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
    '';

    home.activation.channelsOverride = lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
      [ -e $HOME/.nix-defexpr/nixos ] || ln -svf ${nixpkgs} $HOME/.nix-defexpr/nixos
      '';
  };
}
