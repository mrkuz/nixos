{ pkgs, inputs, ... }:

{
  imports = [
    (import ../markus/home.nix { inherit pkgs; inherit inputs; })
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = [
   # Miscellaneous
   pkgs.gitAndTools.gitFull
   pkgs.gocr
   pkgs.imagemagick
   pkgs.html-tidy
   pkgs.mkvtoolnix-cli
   pkgs.potrace
   pkgs.protobuf
   # Applications
   pkgs.android-studio
   pkgs.google-chrome
   pkgs.jetbrains.idea-community
   pkgs.netbeans
   pkgs.postman
   pkgs.robo3t
   pkgs.skypeforlinux
   pkgs.spotify
   pkgs.steam
   pkgs.steam-run
   pkgs.vscode
  ];
}
