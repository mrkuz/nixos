{ pkgs, inputs, vars, ... }:

{
  imports = [
    ../markus/home.nix
  ];

  modules = {
    borgBackup.enable = true;
    chromium.enable = true;
    cloudTools.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    disableBluetooth.enable = true;
    emacs.enable = true;
    javaDevelopment.enable = true;
  };

  home.file.".gitconfig".source = ./files/.gitconfig;

  home.packages = with pkgs; [
    gitAndTools.diff-so-fancy
    gitAndTools.gitFull
    lens
    postman
    zoom-us
  ];
}
