{ config, pkgs, inputs, vars, sources, ... }:

let
  hm = inputs.home-manager.lib.hm;
  user = config.home.username;
in
{
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
}
