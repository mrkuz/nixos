{ config, lib, pkgs, nixpkgs, self, inputs, vars, systemName, ... }:

{
  imports = [
    ../../modules/nixos/android.nix
    ../../modules/nixos/avahi.nix
    ../../modules/nixos/base-packages.nix
    ../../modules/nixos/btrfs.nix
    ../../modules/nixos/command-not-found.nix
    ../../modules/nixos/compatibility.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/ecryptfs.nix
    ../../modules/nixos/emacs.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/grub-efi.nix
    ../../modules/nixos/kde.nix
    ../../modules/nixos/kodi.nix
    ../../modules/nixos/kvm.nix
    ../../modules/nixos/libreoffice.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/opengl.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/resolved.nix
    ../../modules/nixos/snapper.nix
    ../../modules/nixos/sshd.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/systemd-boot.nix
    ../../modules/nixos/virtualbox.nix
    ../../modules/nixos/waydroid.nix
    ../../modules/nixos/wayland.nix
    ../../modules/nixos/x11.nix
  ];

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
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "de_AT.UTF-8/UTF-8"
  ];

  networking.firewall.enable = true;
  networking.useDHCP = false;
  networking.dhcpcd.wait = "background";

  # Speed up boot / shut down
  systemd.services.systemd-udev-settle.enable = false;
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

  system.name = systemName;
  system.stateVersion = vars.stateVersion;
  system.configurationRevision = self.rev or "dirty";
}
