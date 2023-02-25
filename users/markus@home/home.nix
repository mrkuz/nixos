{ config, pkgs, inputs, vars, ... }:

let
  sources = import ../../nix/sources.nix;
  hm = inputs.home-manager.lib.hm;
  user = config.home.username;
in
{
  imports = [
    ../markus/home.nix
  ];

  modules = {
    borgBackup.enable = true;
    chromium.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    devShells = {
      enable = true;
      shells = [
        (import ../../modules/home-manager/shells/android.nix)
        (import ../../modules/home-manager/shells/build.nix)
        (import ../../modules/home-manager/shells/devops.nix)
        (import ../../modules/home-manager/shells/fhs.nix)
        (import ../../modules/home-manager/shells/graalvm.nix)
        (import ../../modules/home-manager/shells/java.nix)
        (import ../../modules/home-manager/shells/sdkman.nix)
        (import ../../modules/home-manager/shells/web.nix)
      ];
    };
    disableBluetooth.enable = true;
    emacs.enable = true;
    idea = {
      enable = true;
      plugins = with pkgs; [
        idea-plugins.checkstyle-idea
        idea-plugins.kotest
        idea-plugins.mybatisx
      ];
    };
    vscodeProfiles = {
      enable = true;
      profiles = [
        (import ../../modules/home-manager/vscode-profiles/devops.nix)
        (import ../../modules/home-manager/vscode-profiles/java.nix)
        (import ../../modules/home-manager/vscode-profiles/nix.nix)
        (import ../../modules/home-manager/vscode-profiles/python.nix)
        (import ../../modules/home-manager/vscode-profiles/web.nix)
      ];
    };
  };

  services.syncthing = {
    enable = true;
  };

  systemd.user.tmpfiles.rules = [
    "L  %h/Backup -  -  -  -  /data/user/${user}/Backup"
  ];

  home.activation.activateExtra = hm.dag.entryAfter [ "writeBoundary" ]
    ''
      # Clone repositories
      [ -e $HOME/src/dockerfiles ] || (cd $HOME/src && ${pkgs.git}/bin/git clone "https://github.com/mrkuz/dockerfiles")
    '';

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
    # lutris
    # mangohud
    # mkvtoolnix-cli
    # potrace
    protobuf
    (python3.withPackages (ps: [ ps.black ps.jinja2 ps.pip ps.requests ps.tkinter ]))
    python310Packages.pdfx
    youtube-dl
    # Java development
    # eclipse-mat
    # visualvm
    # Applications
    android-studio
    # calibre
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
    zoom-us
  ];
}
