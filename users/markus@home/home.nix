{ pkgs, inputs, ... }:

{
  imports = [
    (import ../markus/home.nix { inherit pkgs; inherit inputs; })
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
    # curlftpfs
    gitAndTools.diff-so-fancy
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
    youtube-dl
    # Applications
    android-studio
    calibre
    gimp
    jetbrains.idea-community
    lens
    netbeans
    postman
    qbittorrent
    spotify
    steam
    steam-run
  ];
}
