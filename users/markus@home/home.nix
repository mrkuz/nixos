{ config, pkgs, inputs, vars, ... }:

let
  sources = import ../../nix/sources.nix;
  vscodeExtensions = with sources; [
    vscode-emacs-friendly
    vscode-theme-darcula
    vscode-icons
    vscodeintellicode
    vscode-status-bar-format-toggle
    markdown-preview-github-styles
    # remote-ssh
  ];
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
    cloudTools.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    disableBluetooth.enable = true;
    emacs.enable = true;
    javaDevelopment.enable = true;
    vscodeProfiles = {
      enable = true;
      profiles = [
        {
          name = "Java";
          alias = "jcode";
          extensions = with sources; vscodeExtensions ++ [
            sonarlint-vscode
            vscode-lombok
            vscode-xml
            java # dependency for vscode-spring-boot-dashboard, vscode-java-pack
            vscode-java-debug # dependency for vscode-spring-boot-dashboard, vscode-java-pack
            vscode-java-dependency # dependency for vscode-java-pack
            vscode-java-test # dependency for vscode-java-pack
            vscode-maven # dependency for vscode-java-pack
            vscode-spring-boot # dependency for vscode-spring-boot-dashboard, vscode-boot-dev-pack
            vscode-spring-initializr # dependency for vscode-boot-dev-pack
            vscode-spring-boot-dashboard # dependency for vscode-boot-dev-pack
            # vscode-boot-dev-pack
            vscode-java-pack
          ];
        }
        {
          name = "JavaScript";
          alias = "jscode";
          extensions = with sources; vscodeExtensions ++ [
            color-highlight
            auto-close-tag # dependency auto-complete-tag
            auto-rename-tag # dependency auto-complete-tag
            auto-complete-tag # dependency for vuejs-extension-pack
            javascriptsnippets # dependency for vuejs-extension-pack
            prettier-vscode # dependency for vuejs-extension-pack
            vetur # dependency for vuejs-extension-pack
            vscode-eslint # dependency for vuejs-extension-pack
            vue-vscode-snippets # dependency for vuejs-extension-pack
            vuejs-extension-pack
          ];
        }
        {
          name = "DevOps";
          alias = "dcode";
          extensions = with sources; vscodeExtensions ++ [
            nix
            terraform
            vscode-ansible
            vscode-yaml # dependency for vscode-docker, vscode-kubernetes-tools
            vscode-docker
            vscode-kubernetes-tools
          ];
        }
        {
          name = "Nix";
          alias = "ncode";
          extensions = with sources; vscodeExtensions ++ [
            nix-ide
          ];
        }
        {
          name = "Python";
          alias = "pcode";
          extensions = with sources; vscodeExtensions ++ [
            python
            vscode-pylance # dependency for python
            # jupyter # dependency for python
            # jupyter-keymap # dependency for jupyter
            # jupyter-renderers # dependency for jupyter
            black-formatter
          ];
        }
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
      [ -e $HOME/src/vagrant-k3s ] || (cd $HOME/src && ${pkgs.git}/bin/git clone "https://github.com/mrkuz/vagrant-k3s")
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
    lutris
    mangohud
    # mkvtoolnix-cli
    nodejs
    # potrace
    protobuf
    (python3.withPackages (ps: [ ps.black ps.jinja2 ps.pip ps.requests ps.tkinter ]))
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
