{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ./minimal.nix
  ];

  modules = {
    nix.enable = true;
  };

  systemd.services.nix-daemon.enable = true;
  systemd.sockets.nix-daemon.enable = true;
}
