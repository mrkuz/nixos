{ config, pkgs, inputs, vars, sources, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
{
  imports = [
    ../../profiles/users/nixos.nix
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
