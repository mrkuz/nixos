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
   pkgs.go
   pkgs.gocr
   pkgs.imagemagick
   pkgs.jq
   pkgs.html-tidy
   # pkgs.mkvtoolnix-cli
   pkgs.nodejs
   # pkgs.potrace
   pkgs.protobuf
   pkgs.python3
   # Applications
   pkgs.android-studio
   pkgs.jetbrains.idea-community
   pkgs.netbeans
   pkgs.postman
   pkgs.robo3t
   pkgs.skypeforlinux
   pkgs.spotify
   pkgs.steam
   pkgs.steam-run
  ];
}
