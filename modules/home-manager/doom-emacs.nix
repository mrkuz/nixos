{ config, lib, pkgs, ... }:

with lib;
let
  sources = import ../../nix/sources.nix;
  cfg = config.modules.doomEmacs;
in
{
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
    home.activation.doomEmacs = hm.dag.entryAfter [ "writeBoundary" ]
      ''
        if [ ! -d $HOME/.emacs.d ]; then
          git clone --depth 1 ${sources.doom-emacs.repo} $HOME/.emacs.d
        fi

        cd $HOME/.emacs.d
        if [ $(git rev-parse HEAD) != ${sources.doom-emacs.rev} ]; then
          git fetch
          git checkout ${sources.doom-emacs.rev}
          ./bin/doom sync
        fi
      '';
  };
}
