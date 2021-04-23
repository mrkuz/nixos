{ config, pkgs, nixpkgs, rev, ... }:

{
  imports = [
    ../../modules/nixos/android.nix
    ../../modules/nixos/avahi.nix
    ../../modules/nixos/base-packages.nix
    ../../modules/nixos/command-not-found.nix
    ../../modules/nixos/compatibility.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/emacs.nix
    ../../modules/nixos/gnome3.nix
    ../../modules/nixos/grub-efi.nix
    ../../modules/nixos/kvm.nix
    ../../modules/nixos/libreoffice.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/opengl.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/resolved.nix
    ../../modules/nixos/virtualbox.nix
    ../../modules/nixos/wayland.nix
    ../../modules/nixos/x11.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "udev.log_priority=3" ];

  networking.useDHCP = false;
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  # Speed up boot / shut down
  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.dhcpcd.wait = "background";
  systemd.extraConfig = "DefaultTimeoutStopSec=30s";

  # Clear old logs
  services.journald.extraConfig = "MaxRetentionSec=14day";

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      narinfo-cache-positive-ttl = 3600
      auto-optimise-store = true
      repeat = 0
    '';

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  environment.etc."nixos/configuration.nix".source = ./files/configuration.nix;
  environment.extraInit = ''
    export NIX_PATH="nixpkgs=/nix/channels/nixos"
  '';
  system.activationScripts.nixpath = ''
    [ -d /nix/channels ] || mkdir /nix/channels
    rm -f /nix/channels/nixos
    ln -s ${nixpkgs} /nix/channels/nixos
  '';

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "*";
      };
    };
  };

  system.stateVersion = "20.09";
  system.configurationRevision = rev;
}
