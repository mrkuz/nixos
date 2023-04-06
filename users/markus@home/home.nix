{ config, lib, pkgs, sources, ... }:

let
  user = config.home.username;

  python-custom = pkgs.python3.withPackages (ps: with ps; [
    black
    jinja2
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
        (import ../../profiles/dev-shells/java.nix)
        (import ../../profiles/dev-shells/sdkman.nix)
      ];
    };
    emacs.enable = true;
    idea = {
      enable = true;
      plugins = with pkgs; [
        idea-plugins.checkstyle-idea
        idea-plugins.kotest
      ];
    };
    vscodeProfiles = {
      enable = true;
      profiles = [
        (import ../../profiles/vscode/nix.nix)
      ];
    };
  };

  services.syncthing = {
    enable = true;
  };

  systemd.user.tmpfiles.rules = [
    "L  %h/Backup -  -  -  -  /data/users/${user}/Backup"
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
      { id = "chklaanhfefbnpoihckbnefhakgolnmc"; } # JSONView
      { id = "jnihajbhpnppcggbcgedagnkighmdlei"; } # LiveReload
      { id = "nlbjncdgjeocebhnmkbbbdekmmmcbfjd"; } # RSS Subscription extension
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];
  };

  home.packages = with pkgs; [
    exiftool
    gitAndTools.diff-so-fancy
    gitAndTools.gitFull
    gocr
    imagemagick
    pdftk
    protobuf
    python-custom
    sox
    youtube-dl
    # Applications
    android-studio
    # audacity
    gimp
    # lutris
    # mangohud
    # steam
    whatsapp-for-linux
    zoom-us
  ];
}
