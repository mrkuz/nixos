{ pkgs, inputs, ... }:

{
  imports = [
    (import ../markus/home.nix { inherit pkgs; inherit inputs; })
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
    audacity
    # curlftpfs
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
    jetbrains.idea-community
    lens
    # netbeans
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
