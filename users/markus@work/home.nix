{ pkgs, inputs, ... }:

{
  imports = [
    (import ../markus/home.nix { inherit pkgs; inherit inputs; })
  ];

  home.file.".gitconfig".source = ./files/.gitconfig;
  home.file.".conkyrc".source = ./files/.conkyrc;

  home.packages = [
   # Miscellaneous
   pkgs.gitAndTools.gitFull
   pkgs.gocr
   pkgs.imagemagick
   pkgs.html-tidy
   pkgs.mongodb-tools
   pkgs.potrace
   pkgs.protobuf
   # Applications
   pkgs.android-studio
   pkgs.charles
   pkgs.firefox
   pkgs.google-chrome
   pkgs.jetbrains.idea-community
   pkgs.netbeans
   pkgs.postman
   pkgs.robo3t
   pkgs.skypeforlinux
   pkgs.zoom-us
  ];
}
