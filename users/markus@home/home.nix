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
    hugo
    html-tidy
    # mkvtoolnix-cli
    nodejs
    # potrace
    protobuf
    python3
    python39Packages.pdfx
    youtube-dl
    # Applications
    android-studio
    calibre
    gimp
    jetbrains.idea-community
    lens
    # netbeans
    pdftk
    postman
    qbittorrent
    spotify
    # skypeforlinux
    thunderbird
    whatsapp-for-linux
  ];
}
