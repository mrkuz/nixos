{ pkgs, inputs, ... }:
let
  vscodeExtensions = with pkgs; [
    vscode-extensions.ms-vsliveshare.vsliveshare
    (callPackage ../../pkgs/vscode/bracket-pair-colorizer-2.nix {})
    (callPackage ../../pkgs/vscode/vscode-emacs-friendly.nix {})
    (callPackage ../../pkgs/vscode/vscode-theme-darcula.nix {})
    (callPackage ../../pkgs/vscode/vscode-icons.nix {})
    (callPackage ../../pkgs/vscode/vscode-status-bar-format-toggle.nix {})
  ];
  hm = inputs.home-manager.lib.hm;
  sources = import ../../nix/sources.nix;
in {
  imports = [
    ../_all/home.nix
  ];

  modules = {
    bash.enable = true;
    cloudPackages.enable = true;
    conky.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    doomEmacs.enable = true;
    javaPackages.enable = true;
    vscodeProfiles = {
      enable = true;
      configSource = "${inputs.dotfiles}/.config/Code/User";
      profiles = [
        {
          name = "Java";
          extensions = with pkgs; [
            (callPackage ../../pkgs/vscode/vscode-lombok.nix {})
            (callPackage ../../pkgs/vscode/vscode-boot-dev-pack.nix {})
            (callPackage ../../pkgs/vscode/vscode-xml.nix {})
            (callPackage ../../pkgs/vscode/vscode-java-pack.nix {})
            (callPackage ../../pkgs/vscode/sonarlint-vscode.nix {})
          ] ++ vscodeExtensions;
        }
        {
          name = "JavaScript";
          extensions = with pkgs; [
            (callPackage ../../pkgs/vscode/vuejs-extension-pack.nix {})
            (callPackage ../../pkgs/vscode/color-highlight.nix {})
          ] ++ vscodeExtensions;
        }
        {
          name = "DevOps";
          extensions = with pkgs; [
            (callPackage ../../pkgs/vscode/terraform.nix {})
            (callPackage ../../pkgs/vscode/vscode-docker.nix {})
            (callPackage ../../pkgs/vscode/vscode-kubernetes-tools.nix {})
            (callPackage ../../pkgs/vscode/vscode-ansible.nix {})
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

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  home.packages = with pkgs; [
    # Emacs dependencies
    graphviz
    hugo
    pandoc
    pdftk
    plantuml
    silver-searcher
    texlive.combined.scheme-basic
  ];

  home.file."/opt/reveal.js" = {
    source = sources.revealjs;
    recursive = true;
  };

  programs.vscode = {
    enable = true;
    extensions = vscodeExtensions;
  };

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

  programs.fzf.enable = true;

  home.activation.activate = hm.dag.entryAfter [ "installPackages" ]
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
