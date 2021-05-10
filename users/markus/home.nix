{ pkgs, inputs, ... }:

let
  sources = import ../../nix/sources.nix;
  vscodeExtensions = with sources; [
    bracket-pair-colorizer-2
    vscode-emacs-friendly
    vscode-theme-darcula
    vscode-icons
    vscodeintellicode
    vscode-status-bar-format-toggle
  ];
  hm = inputs.home-manager.lib.hm;
in {
  imports = [
    ../_all/home.nix
  ];

  modules = {
    bash.enable = true;
    chromium.enable = true;
    cloudPackages.enable = true;
    conky.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    doomEmacs.enable = true;
    emacs.enable = true;
    javaPackages.enable = true;
    vscodeProfiles = {
      enable = true;
      profiles = [
        {
          name = "Java";
          alias = "jcode";
          extensions = with sources; [
            vscode-lombok
            vscode-boot-dev-pack
            vscode-xml
            vscode-java-pack
            sonarlint-vscode
            java
            vscode-java-debug
            vscode-java-dependency
            vscode-java-test
            vscode-maven
            vscode-spring-boot-dashboard
            vscode-spring-boot
          ] ++ vscodeExtensions;
        }
        {
          name = "JavaScript";
          alias = "jscode";
          extensions = with sources; [
            vuejs-extension-pack
            color-highlight
          ] ++ vscodeExtensions;
        }
        {
          name = "DevOps";
          alias = "dcode";
          extensions = with sources; [
            nix
            terraform
            vscode-docker
            vscode-kubernetes-tools
            vscode-ansible
            vscode-yaml
          ] ++ vscodeExtensions;
        }
      ];
    };
  };

  home.file."/" = {
    source = inputs.dotfiles;
    recursive = true;
  };

  home.file.".doom.d" = {
    source = inputs.doomd;
    recursive = true;
  };

  systemd.user.services.rfkill = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart= "${pkgs.util-linux}/bin/rfkill block bluetooth";
    };

    Unit = {
      Description = "Disable bluetooth";
    };
  };

  home.activation.activate = hm.dag.entryAfter [ "writeBoundary" ]
    ''
    # Create directories
    [ -e $HOME/bin ] || mkdir $HOME/bin
    [ -e $HOME/etc ] || mkdir $HOME/etc
    [ -e $HOME/org ] || mkdir -p $HOME/org/{calendar,lists,mobile,projects}
    [ -e $HOME/tmp ] || mkdir $HOME/tmp
    [ -e $HOME/Games ] || mkdir $HOME/Games
    [ -e $HOME/Notes ] || mkdir $HOME/Notes
    [ -e $HOME/opt ] || mkdir $HOME/opt
    [ -e $HOME/src ] || mkdir $HOME/src
    [ -e $HOME/Workspace ] || mkdir $HOME/Workspace

    # Link some stuff
    [ -e $HOME/Backup ] || ln -svf /data/user/$USER/Backup $HOME/Backup
    [ -e $HOME/etc/dotfiles ] || ln -svf $HOME/etc/nixos/repos/dotfiles $HOME/etc/dotfiles
    [ -e $HOME/etc/doom.d ] || ln -svf $HOME/etc/nixos/repos/doom.d $HOME/etc/doom.d

    # Clone repositories
    [ -e $HOME/etc/nix-shell ] || (cd $HOME/etc && ${pkgs.git}/bin/git clone "https://github.com/mrkuz/nix-shell")
    [ -e $HOME/src/vagrant-k3s ] || (cd $HOME/src && ${pkgs.git}/bin/git clone "https://github.com/mrkuz/vagrant-k3s")
    [ -e $HOME/src/dockerfiles ] || (cd $HOME/src && ${pkgs.git}/bin/git clone "https://github.com/mrkuz/dockerfiles")
    '';
}
