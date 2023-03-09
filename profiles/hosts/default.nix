{ config, lib, pkgs, nixpkgs, self, inputs, vars, systemName, ... }:

{
  modules = {
    nix.enable = true;
  };

  boot = {
    cleanTmpDir = true;
    consoleLogLevel = 0;
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "udev.log_priority=3"
      # "systemd.unified_cgroup_hierarchy=0"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "net.ipv4.ip_forward" = 1;
      "fs.inotify.max_user_instances" = 524288;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  time.timeZone = "Europe/Vienna";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "de_AT.UTF-8/UTF-8"
    ];
  };

  networking = {
    firewall.enable = lib.mkDefault true;
    useDHCP = false;
    dhcpcd.wait = "background";
  };

  # Speed up boot / shut down
  systemd.services.systemd-udev-settle.enable = false;
  # systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.extraConfig = "DefaultTimeoutStopSec=30s";

  # Delete old logs
  services.journald.extraConfig = "MaxRetentionSec=14day";

  # Not working with cgroup v1
  # systemd.oomd.enable = false;

  documentation = {
    enable = true;
    doc.enable = false;
    info.enable = false;
    man.enable = true;
    nixos.enable = true;
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "*";
      };
    };
  };
}
