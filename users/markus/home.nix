{ pkgs, inputs, vars, ... }:

let
  sources = import ../../nix/sources.nix;
  hm = inputs.home-manager.lib.hm;
in {
  imports = [
    ../_all/home.nix
  ];

  modules = {
    bash.enable = true;
    fish.enable = true;
  };

  home.file."tmp/../" = {
    source = inputs.dotfiles;
    recursive = true;
  };

  programs.fish.plugins = [
    {
      name = "fish-kubectl-completions";
      src = sources.fish-kubectl-completions;
    }
  ];

  home.activation.activate = hm.dag.entryAfter [ "writeBoundary" ]
    ''
    # Create directories
    [ -e $HOME/bin ] || mkdir $HOME/bin
    [ -e $HOME/etc ] || mkdir $HOME/etc
    [ -e $HOME/org ] || mkdir -p $HOME/org/{calendar,lists,mobile,projects}
    [ -e $HOME/tmp ] || mkdir $HOME/tmp
    [ -e $HOME/Games ] || mkdir $HOME/Games
    [ -e $HOME/Notes ] || mkdir $HOME/Notes
    [ -e $HOME/opt ] || mkdir $HOME/opt
    [ -e $HOME/src ] || mkdir $HOME/src
    [ -e $HOME/Workspace ] || mkdir $HOME/Workspace

    # Link some stuff
    [ -e $HOME/etc/dotfiles ] || ln -svf $HOME/etc/nixos/repos/dotfiles $HOME/etc/dotfiles
    [ -e $HOME/etc/emacs.d ] || ln -svf $HOME/etc/nixos/repos/emacs.d $HOME/etc/emacs.d
    [ -e $HOME/.emacs.d ] || ln -svf $HOME/etc/emacs.d $HOME/.emacs.d
    '';
}
