{ pkgs, inputs, vars, ... }:

{
  imports = [
    ../markus/home.nix
  ];

  modules = {
    chromium.enable = true;
    cloudTools.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    disableBluetooth.enable = true;
    emacs.enable = true;
    javaDevelopment.enable = true;
  };

  home.file.".gitconfig".source = ./files/.gitconfig;

  home.activation.activate = hm.dag.entryAfter [ "writeBoundary" ]
    ''
    # Create directories
    [ -e $HOME/bin ] || mkdir $HOME/bin
    [ -e $HOME/etc ] || mkdir $HOME/etc
    [ -e $HOME/org ] || mkdir -p $HOME/org/{calendar,lists,mobile,projects}
    [ -e $HOME/tmp ] || mkdir $HOME/tmp
    [ -e $HOME/Notes ] || mkdir $HOME/Notes
    [ -e $HOME/opt ] || mkdir $HOME/opt
    [ -e $HOME/src ] || mkdir $HOME/src
    [ -e $HOME/Workspace ] || mkdir $HOME/Workspace

    # Link some stuff
    [ -e $HOME/etc/dotfiles ] || ln -svf $HOME/etc/nixos/repos/dotfiles $HOME/etc/dotfiles
    [ -e $HOME/etc/emacs.d ] || ln -svf $HOME/etc/nixos/repos/emacs.d $HOME/etc/emacs.d
    [ -e $HOME/.emacs.d ] || ln -svf $HOME/etc/emacs.d $HOME/.emacs.d
    '';

  home.packages = with pkgs; [
    # Miscellaneous
    gitAndTools.gitFull
    gocr
    imagemagick
    html-tidy
    mongodb-tools
    mongodb-4_2
    mysql
    potrace
    protobuf
    # Applications
    android-studio
    charles
    firefox
    google-chrome
    netbeans
    postman
    robo3t
    skypeforlinux
    wkhtmltopdf
    zoom-us
  ];
}
