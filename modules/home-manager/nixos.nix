{ config, lib, pkgs, nixpkgs, ... }:

with lib;
let
  cfg = config.modules.nixos;
in {
  options.modules.nixos = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    home.activation.channels = hm.dag.entryAfter [ "writeBoundary" ] ''
      [ -e $HOME/.nix-defexpr ] || mkdir $HOME/.nix-defexpr
      rm -f $HOME/.nix-defexpr/channels
      touch $HOME/.nix-defexpr/channels
      rm -f $HOME/.nix-defexpr/channels_root
      touch $HOME/.nix-defexpr/channels_root
      [ -e $HOME/.nix-defexpr/nixos ] || ln -svf /nix/channels/nixos $HOME/.nix-defexpr/nixos
    '';
  };
}
