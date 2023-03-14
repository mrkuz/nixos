{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ./minimal.nix
  ];

  boot.isContainer = true;
  boot.specialFileSystems = lib.mkForce { };
  system.disableInstallerTools = true;

  networking = {
    hostName = "";
  };

  systemd.services.console-getty.enable = false;
  # systemd.services.systemd-logind.enable = false;
  # systemd.services."serial-getty@ttyS0".enable = false;
  # systemd.services."serial-getty@hvc0".enable = false;
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@".enable = false;

  # nix.settings.sandbox = false;

  users = {
    mutableUsers = false;
    allowNoPasswordLogin = true;
    users = {
      root = {
        hashedPassword = "*";
      };
    };
  };
}
