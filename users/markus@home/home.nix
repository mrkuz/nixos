{ config, pkgs, inputs, vars, ... }:

let
  sources = import ../../nix/sources.nix;
  vscodeExtensions = [
    sources."vscode:intellicode-api-usage-examples" # dependency for vscodeintellicode
    sources."vscode:markdown-preview-github-styles"
    sources."vscode:vscode-emacs-friendly"
    sources."vscode:vscode-theme-darcula"
    sources."vscode:vscode-icons"
    sources."vscode:vscode-status-bar-format-toggle"
    sources."vscode:vscodeintellicode"
    # sources."vscode:remote-ssh"
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
          extensions = vscodeExtensions ++ [
            sources."vscode:java" # dependency for vscode-spring-boot-dashboard, vscode-java-pack
            sources."vscode:sonarlint-vscode"
            sources."vscode:vscode-java-debug" # dependency for vscode-spring-boot-dashboard, vscode-java-pack
            sources."vscode:vscode-java-dependency" # dependency for vscode-java-pack
            sources."vscode:vscode-java-pack"
            sources."vscode:vscode-java-test" # dependency for vscode-java-pack
            sources."vscode:vscode-lombok"
            sources."vscode:vscode-maven" # dependency for vscode-java-pack
            sources."vscode:vscode-spring-boot" # dependency for vscode-spring-boot-dashboard, vscode-boot-dev-pack
            sources."vscode:vscode-spring-boot-dashboard" # dependency for vscode-boot-dev-pack
            sources."vscode:vscode-spring-initializr" # dependency for vscode-boot-dev-pack
            sources."vscode:vscode-xml"
            # sources."vscode-boot-dev-pack"
          ];
        }
        {
          name = "JavaScript";
          alias = "jscode";
          extensions = vscodeExtensions ++ [
            sources."vscode:auto-close-tag" # dependency auto-complete-tag
            sources."vscode:auto-complete-tag" # dependency for vuejs-extension-pack
            sources."vscode:auto-rename-tag" # dependency auto-complete-tag
            sources."vscode:color-highlight"
            sources."vscode:javascriptsnippets" # dependency for vuejs-extension-pack
            sources."vscode:npm-intellisense" # dependency for vuejs-extension-pack
            sources."vscode:prettier-vscode" # dependency for vuejs-extension-pack
            sources."vscode:vetur" # dependency for vuejs-extension-pack
            sources."vscode:vite" # dependency for vuejs-extension-pack
            sources."vscode:vitest-explorer" # dependency for vuejs-extension-pack
            sources."vscode:volar" # dependency for vuejs-extension-pack
            sources."vscode:vscode-eslint" # dependency for vuejs-extension-pack
            sources."vscode:vscode-typescript-vue-plugin" # dependency for vuejs-extension-pack
            sources."vscode:vue-vscode-snippets" # dependency for vuejs-extension-pack
            sources."vscode:vuejs-extension-pack"
          ];
        }
        {
          name = "DevOps";
          alias = "dcode";
          extensions = vscodeExtensions ++ [
            sources."vscode:nix"
            sources."vscode:terraform"
            sources."vscode:vscode-ansible"
            sources."vscode:vscode-docker"
            sources."vscode:vscode-kubernetes-tools"
            sources."vscode:vscode-yaml" # dependency for vscode-docker, vscode-kubernetes-tools
          ];
        }
        {
          name = "Nix";
          alias = "ncode";
          extensions = vscodeExtensions ++ [
            sources."vscode:nix-ide"
          ];
        }
        {
          name = "Python";
          alias = "pcode";
          extensions = vscodeExtensions ++ [
            sources."vscode:python"
            sources."vscode:isort" # dependency for python
            sources."vscode:vscode-pylance" # dependency for python
            sources."vscode:jupyter" # dependency for python
            sources."vscode:jupyter-keymap" # dependency for jupyter
            sources."vscode:jupyter-renderers" # dependency for jupyter
            sources."vscode:black-formatter"
            sources."vscode:vscode-jupyter-cell-tags" # dependency for jupyter
            sources."vscode:vscode-jupyter-slideshow" # dependency for jupyter
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
    zoom-us
  ];
}
