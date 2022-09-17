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
}
