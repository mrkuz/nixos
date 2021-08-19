{ pkgs, inputs, ... }:

{
  imports = [
    ../_all/home.nix
  ];

  modules = {
    bash.enable = true;
  };

  home.file."tmp/../" = {
    source = inputs.dotfiles;
    recursive = true;
  };

  home.file.".gitconfig".source = ./files/.gitconfig;

  home.packages = with pkgs; [
    gitAndTools.gitFull
  ];
}
