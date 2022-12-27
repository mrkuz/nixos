{ config, lib, pkgs, vars, ... }:

with lib;
let
  cfg = config.modules.emacs;
  emacsPkg = (getAttr vars.emacs pkgs);
in
{
  options.modules.emacs = {
    enable = mkOption {
      default = false;
      type = types.bool;
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
      (callPackage ../../pkgs/misc/revealjs { })
    ] ++ [ ((pkgs.emacsPackagesFor emacsPkg).emacsWithPackages (epkgs: [ epkgs.vterm ])) ];

    systemd.user.services.emacs = {
      Unit = {
        Description = "Emacs text editor";
        Documentation = "info:emacs man:emacs(1) https://gnu.org/software/emacs/";
        X-RestartIfChanged = false;
        RefuseManualStart = true;
      };

      Service = {
        Type = "notify";
        ExecStart = "${pkgs.runtimeShell} -l -c \"${emacsPkg}/bin/emacs --fg-daemon\"";
        SuccessExitStatus = 15;
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "default.target" ]; };
    };

    home.file.".local/share/applications/org-protocol.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Org-Protocol
        Exec=${emacsPkg}/bin/emacsclient -a "" -n -c -F '((name . "org-protocol-capture"))' '%u'
        NoDisplay=true
        Icon=emacs
        Type=Application
        Terminal=false
        MimeType=x-scheme-handler/org-protocol
      '';
    };
  };
}
