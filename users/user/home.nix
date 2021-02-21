{ pkgs, inputs, ... }:

{
  imports = [
    ../_all/home.nix
  ];

  home.file."/" = {
    source = inputs.dotfiles;
    recursive = true;
  };

  home.file.".doom.d" = {
    source = inputs.doomd;
    recursive = true;
  };

  home.file.".gitconfig".source = ./files/.gitconfig;

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.fzf.enable = true;

  home.packages = with pkgs; [
    gitAndTools.gitFull
  ];

  modules = {
    bash.enable = true;
    # cloudPackages.enable = true;
    # conky.enable = true;
    # javaPackages.enable = true;
    # dconf = {
    #  enable = true;
    #  iniFile = ../markus/files/dconf.ini;
    # };
    # doomEmacs.enable = true;
    # vscodeProfiles.enable = true;
  };
}
