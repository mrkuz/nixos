{ pkgs, inputs, vars, ... }:

{
  imports = [
    ../markus/home.nix
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
    audacity
    # curlftpfs
    exiftool
    gitAndTools.diff-so-fancy
    gitAndTools.gitFull
    go
    gocr
    imagemagick
    hey
    hugo
    html-tidy
    lutris
    mangohud
    # mkvtoolnix-cli
    nodejs
    # potrace
    protobuf
    (python3.withPackages(ps: [ ps.black ps.jinja2 ps.pip ps.requests ps.tkinter ]))
    python310Packages.pdfx
    youtube-dl
    # Applications
    android-studio
    calibre
    gimp
    lens
    pdftk
    postman
    qbittorrent
    # sox
    spotify
    steam
    # skypeforlinux
    whatsapp-for-linux
  ];
}
