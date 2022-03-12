{ pkgs, inputs, ... }:

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
in {
  imports = [
    ../_all/home.nix
  ];

  modules = {
    bash.enable = true;
    chromium.enable = true;
    cloudPackages.enable = true;
    dconf = {
      enable = true;
      iniFile = ../markus/files/dconf.ini;
    };
    disableBluetooth.enable = true;
    emacs.enable = true;
    fish.enable = true;
    javaPackages.enable = true;
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
            java  # dependency for vscode-spring-boot-dashboard, vscode-java-pack
            vscode-java-debug  # dependency for vscode-spring-boot-dashboard, vscode-java-pack
            vscode-java-dependency # dependency for vscode-java-pack
            vscode-java-test # dependency for vscode-java-pack
            vscode-maven # dependency for vscode-java-pack
            vscode-spring-boot # dependency for vscode-spring-boot-dashboard, vscode-boot-dev-pack
            vscode-spring-initializr # dependency for vscode-boot-dev-pack
            vscode-spring-boot-dashboard  # dependency for vscode-boot-dev-pack
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
      ];
    };
  };

  home.file."tmp/../" = {
    source = inputs.dotfiles;
    recursive = true;
  };

  # home.file.".emacs.d" = {
  #  source = inputs.emacsd;
  #  recursive = true;
  # };

  programs.fish.plugins = [
    {
      name = "fish-kubectl-completions";
      src = sources.fish-kubectl-completions;
    }
  ];

  home.activation.activate = hm.dag.entryAfter [ "writeBoundary" ]
    ''
    # Create directories
    [ -e $HOME/bin ] || mkdir $HOME/bin
    [ -e $HOME/etc ] || mkdir $HOME/etc
    [ -e $HOME/org ] || mkdir -p $HOME/org/{calendar,lists,mobile,projects}
    [ -e $HOME/tmp ] || mkdir $HOME/tmp
    [ -e $HOME/Games ] || mkdir $HOME/Games
    [ -e $HOME/opt ] || mkdir $HOME/opt
    [ -e $HOME/src ] || mkdir $HOME/src
    [ -e $HOME/Workspace ] || mkdir $HOME/Workspace

    # Link some stuff
    [ -e $HOME/Backup ] || ln -svf /data/user/$USER/Backup $HOME/Backup
    [ -e $HOME/etc/dotfiles ] || ln -svf $HOME/etc/nixos/repos/dotfiles $HOME/etc/dotfiles
    [ -e $HOME/etc/emacs.d ] || ln -svf $HOME/etc/nixos/repos/emacs.d $HOME/etc/emacs.d
    [ -e $HOME/.emacs.d ] || ln -svf $HOME/etc/emacs.d $HOME/.emacs.d

    # Clone repositories
    [ -e $HOME/src/vagrant-k3s ] || (cd $HOME/src && ${pkgs.git}/bin/git clone "https://github.com/mrkuz/vagrant-k3s")
    [ -e $HOME/src/dockerfiles ] || (cd $HOME/src && ${pkgs.git}/bin/git clone "https://github.com/mrkuz/dockerfiles")
    '';
}
