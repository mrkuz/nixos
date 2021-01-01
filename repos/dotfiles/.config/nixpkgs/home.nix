{ pkgs, ... }:

{
  # Emacs
  programs.emacs = {
    enable = true;
  };
  services.emacs = {
    enable = true;
    client.enable = true;
    # client.arguments = [ "-c" "-a" "emacs" ];
  };

  programs.fzf.enable = true;
  services.syncthing = {
    enable = true;
  };

  home.packages = [
   # Emacs dependencies
   pkgs.graphviz
   pkgs.hugo
   pkgs.pandoc
   pkgs.pdftk
   pkgs.plantuml
   pkgs.silver-searcher
   pkgs.sqlite
   pkgs.texlive.combined.scheme-basic
   # Cloud tools
   pkgs.google-cloud-sdk
   pkgs.kubernetes-helm
   pkgs.kubectl
   pkgs.kubetail
   pkgs.minikube
   pkgs.terraform
   # Miscellaneous
   pkgs.android-file-transfer
   pkgs.conky
   pkgs.curlftpfs
   pkgs.gitAndTools.gitFull
   pkgs.gocr
   pkgs.imagemagick
   pkgs.html-tidy
   pkgs.mkvtoolnix-cli
   pkgs.nodejs
   pkgs.potrace
   pkgs.protobuf
   pkgs.x11docker
   # Java
   pkgs.gradle
   pkgs.jdk14
   pkgs.maven
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
   # pkgs.syncthing-gtk
   pkgs.vscode
  ];
}
