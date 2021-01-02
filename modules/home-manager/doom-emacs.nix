{ config, lib, pkgs, ... }:

with lib;
let
  sources = import ../../nix/sources.nix;
  cfg = config.modules.doomEmacs;
in {
  options.modules.doomEmacs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    iniFile = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sqlite
    ];

    home.activation.doomEmacs = hm.dag.entryAfter [ "installPackages" ]
      ''
      if [ ! -d $HOME/.emacs.d ]; then
        git clone --depth 1 ${sources.doom-emacs.repo} $HOME/.emacs.d
      fi

      cd $HOME/.emacs.d
      git fetch
      git checkout ${sources.doom-emacs.rev}
      ./bin/doom sync
      '';
  };
}
