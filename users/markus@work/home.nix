{ pkgs, inputs, vars, ... }:

{
  imports = [
    ../markus/home.nix
  ];

  home.file.".gitconfig".source = ./files/.gitconfig;
  home.file.".conkyrc".source = ./files/.conkyrc;

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
