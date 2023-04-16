{ config, lib, pkgs, sources, ... }:

{
  modules = {
    nix.enable = true;
  };

  boot = {
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "udev.log_priority=3"
    ];
    kernel.sysctl = {
      "fs.inotify.max_queued_events" = 1048576;
      "fs.inotify.max_user_instances" = 1048576;
      "fs.inotify.max_user_watches" = 1048576;
      "kernel.dmesg_restrict" = 1;
      "kernel.keys.maxkeys" = 2000;
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = "1";
      "net.ipv6.conf.default.forwarding" = "1";
      "net.ipv4.neigh.default.gc_thresh3" = 8192;
      "net.ipv6.neigh.default.gc_thresh3" = 8192;
      "vm.max_map_count" = 262144;
      "vm.swappiness" = 10;
    };
    tmp.cleanOnBoot = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  networking = {
    firewall.enable = lib.mkDefault true;
    useDHCP = false;
    dhcpcd.wait = "background";
  };

  # Speed up boot / shut down
  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.extraConfig = "DefaultTimeoutStopSec=30s";

  # Delete old logs
  services.journald.extraConfig = "MaxRetentionSec=14day";

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
