{ pkgs, inputs, ... }:

{
  imports = [
    (import ../markus/home.nix { inherit pkgs; inherit inputs; })
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
   # Miscellaneous
   # curlftpfs
   gitAndTools.gitFull
   go
   gocr
   imagemagick
   hey
   html-tidy
   # mkvtoolnix-cli
   nodejs
   # potrace
   protobuf
   python3
   # Applications
   android-studio
   jetbrains.idea-community
   netbeans
   postman
   robo3t
   skypeforlinux
   spotify
   steam
   steam-run
  ];
}
