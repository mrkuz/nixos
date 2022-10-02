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

    # home.activation.channels = hm.dag.entryAfter [ "writeBoundary" ] ''
    #   [ -e $HOME/.nix-defexpr ] || mkdir $HOME/.nix-defexpr
    #   rm -f $HOME/.nix-defexpr/channels
    #   touch $HOME/.nix-defexpr/channels
    #   rm -f $HOME/.nix-defexpr/channels_root
    #   touch $HOME/.nix-defexpr/channels_root
    # '';

    systemd.user.tmpfiles.rules = [
      "d   %h/.nix-defexpr        0755 ${user} ${user}  -  -"
      "L+  %h/.nix-defexpr/nixos     -       -       -  -  /nix/channels/nixos"
    ];
  };
}
