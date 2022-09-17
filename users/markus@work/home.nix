{ pkgs, inputs, vars, ... }:

{
  imports = [
    ../markus/home.nix
  ];

  modules = {
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
    # Miscellaneous
    gitAndTools.gitFull
    gocr
    imagemagick
    html-tidy
    mongodb-tools
    mongodb-4_2
    mysql
    potrace
    protobuf
    # Applications
    android-studio
    charles
    firefox
    google-chrome
    netbeans
    postman
    robo3t
    skypeforlinux
    wkhtmltopdf
    zoom-us
  ];
}
