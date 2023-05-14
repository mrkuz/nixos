{ config, lib, pkgs, sources, ... }:

let
  user = config.home.username;
in
{
  modules = {
    bash.enable = true;
    fish.enable = true;
  };

  home.file."tmp/../" = {
    source = sources.dotfiles;
    recursive = true;
  };

  programs.fish.plugins = [
    {
      name = "bass";
      src = sources."fish:bass";
    }
    {
      name = "fish-kubectl-completions";
      src = sources."fish:fish-kubectl-completions";
    }
  ];

  systemd.user.tmpfiles.rules = [
    "d  %h/bin           0755 ${user} ${user}  -  -"
    "d  %h/etc           0755 ${user} ${user}  -  -"
    "d  %h/opt           0755 ${user} ${user}  -  -"
    "d  %h/org           0755 ${user} ${user}  -  -"
    "d  %h/org/archive   0755 ${user} ${user}  -  -"
    "d  %h/org/calendar  0755 ${user} ${user}  -  -"
    "d  %h/org/journal   0755 ${user} ${user}  -  -"
    "d  %h/org/lists     0755 ${user} ${user}  -  -"
    "d  %h/org/mobile    0755 ${user} ${user}  -  -"
    "d  %h/org/people    0755 ${user} ${user}  -  -"
    "d  %h/org/projects  0755 ${user} ${user}  -  -"
    "d  %h/org/roles     0755 ${user} ${user}  -  -"
    "d  %h/src           0755 ${user} ${user}  -  -"
    "d  %h/tmp           0755 ${user} ${user}  -  -"
    "d  %h/Games         0755 ${user} ${user}  -  -"
    "d  %h/Notes         0755 ${user} ${user}  -  -"
    "d  %h/Scripts       0755 ${user} ${user}  -  -"
    "d  %h/Shared        0755 ${user} ${user}  -  -"
    "d  %h/Workspace     0755 ${user} ${user}  -  -"
    "L  %h/etc/dotfiles     -       -       -  -  %h/etc/nixos/repos/dotfiles"
    "L  %h/etc/emacs.d      -       -       -  -  %h/etc/nixos/repos/emacs.d"
    "L  %h/.emacs.d         -       -       -  -  %h/etc/emacs.d"
  ];
}
