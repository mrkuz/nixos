{ config, pkgs, inputs, vars, sources, ... }:

let
  hm = inputs.home-manager.lib.hm;
  user = config.home.username;

  python-custom = pkgs.python3.withPackages (ps: with ps; [
    black
    jinja2
    pdfx
    pip
    requests
    tkinter
  ]);
in
{
  imports = [
    ../../profiles/users/nixos.nix
    ../../profiles/users/markus.nix
  ];

  modules = {
    borgBackup.enable = true;
    dconf = {
      enable = true;
      iniFile = ./files/dconf.ini;
    };
    devShells = {
      enable = true;
      shells = [
        (import ./dev-shells/android.nix)
        (import ./dev-shells/build.nix)
        (import ./dev-shells/devops.nix)
        (import ./dev-shells/fhs.nix)
        (import ./dev-shells/graalvm.nix)
        (import ./dev-shells/java.nix)
        (import ./dev-shells/sdkman.nix)
        (import ./dev-shells/web.nix)
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
        (import ./vscode-profiles/devops.nix)
        (import ./vscode-profiles/java.nix)
        (import ./vscode-profiles/nix.nix)
        (import ./vscode-profiles/python.nix)
        (import ./vscode-profiles/web.nix)
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

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
      { id = "chklaanhfefbnpoihckbnefhakgolnmc"; } # JSONView
      { id = "jnihajbhpnppcggbcgedagnkighmdlei"; } # LiveReload
      { id = "nlbjncdgjeocebhnmkbbbdekmmmcbfjd"; } # RSS Subscription extension
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; } # Vimium C
    ];
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
    # lutris
    # mangohud
    # mkvtoolnix-cli
    # potrace
    protobuf
    python-custom
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
