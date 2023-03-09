{ config, lib, pkgs, nixpkgs, self, inputs, vars, systemName, ... }:

{
  boot.enableContainers = false;
  networking.firewall.enable = false;

  systemd.services.nix-daemon.enable = lib.mkDefault false;
  systemd.sockets.nix-daemon.enable = lib.mkDefault false;

  services.logrotate.enable = false;

  environment.defaultPackages = [ ];
  environment.noXlibs = lib.mkDefault true;

  programs.command-not-found.enable = false;

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  xdg = {
    autostart.enable = lib.mkDefault false;
    icons.enable = lib.mkDefault false;
    menus.enable = lib.mkDefault false;
    mime.enable = lib.mkDefault false;
    sounds.enable = false;
  };
}
