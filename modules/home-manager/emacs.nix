{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.emacs;
in
{
  options.modules.emacs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    service = mkOption {
      default = true;
      type = types.bool;
    };
    package = mkOption {
      default = pkgs.emacsPgtk;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Dependencies
      graphviz
      hunspell
      hunspellDicts.de_AT
      hunspellDicts.en_US
      pandoc
      plantuml
      # silver-searcher
      sqlite
      texlive.combined.scheme-basic
      # (callPackage ../../pkgs/misc/revealjs { })
    ] ++ [ ((pkgs.emacsPackagesFor cfg.package).emacsWithPackages (epkgs: [ epkgs.vterm ])) ];

    systemd.user.services.emacs = mkIf cfg.service {
      Unit = {
        Description = "Emacs text editor";
        Documentation = "info:emacs man:emacs(1) https://gnu.org/software/emacs/";
        X-RestartIfChanged = false;
        RefuseManualStart = true;
      };

      Service = {
        Type = "notify";
        ExecStart = "${pkgs.runtimeShell} -l -c \"${cfg.package}/bin/emacs --fg-daemon\"";
        SuccessExitStatus = 15;
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "default.target" ]; };
    };

    home.file.".local/share/applications/org-protocol.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Org-Protocol
        Exec=${cfg.package}/bin/emacsclient -a "" -n -c -F '((name . "org-protocol-capture"))' '%u'
        NoDisplay=true
        Icon=emacs
        Type=Application
        Terminal=false
        MimeType=x-scheme-handler/org-protocol
      '';
    };
  };
}
