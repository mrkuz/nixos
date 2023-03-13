{ pkgs, lib, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
{
  imports = [
    ../../profiles/users/non-nixos.nix
  ];

  modules = {
    bash.enable = true;
    emacs = {
      enable = true;
      service = false;
    };
    fish.enable = true;
  };

  home.file."tmp/../" = {
    source = inputs.dotfiles;
    recursive = true;
  };

  home.packages = with pkgs; [
    bat
    gitAndTools.gitFull
    htop
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];
  };

  systemd.user.tmpfiles.rules = [
    "L  %h/.emacs.d  -  -  -  -  %h/etc/nixos/repos/emacs.d"
  ];

  # Gnome extensions
  xdg.dataFile."gnome-shell/extensions/dynamic-panel-transparency@rockon999.github.io".source = "${pkgs.gnome-shell-extensions.dynamic-panel-transparency}/share/gnome-shell/extensions/dynamic-panel-transparency@rockon999.github.io";
  xdg.dataFile."gnome-shell/extensions/instantworkspaceswitcher@amalantony.net".source = "${pkgs.gnome-shell-extensions.instant-workspace-switcher}/share/gnome-shell/extensions/instantworkspaceswitcher@amalantony.net";
  xdg.dataFile."gnome-shell/extensions/just-perfection-desktop@just-perfection".source = "${pkgs.gnome-shell-extensions.just-perfection}/share/gnome-shell/extensions/just-perfection-desktop@just-perfection";
  xdg.dataFile."gnome-shell/extensions/workspaces-bar@fthx".source = "${pkgs.gnome-shell-extensions.workspaces-bar}/share/gnome-shell/extensions/workspaces-bar@fthx";
}
