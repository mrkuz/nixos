{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ../../profiles/users/nixos.nix
  ];

  modules = {
    bash.enable = true;
    fish.enable = true;
  };

  home.file."tmp/../" = {
    source = sources.dotfiles;
    recursive = true;
  };
}
