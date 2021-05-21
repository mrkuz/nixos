{ config, pkgs, nixpkgs, rev, ... }:

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
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/grub-efi.nix
    ../../modules/nixos/kodi.nix
    ../../modules/nixos/kvm.nix
    ../../modules/nixos/libreoffice.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/opengl.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/resolved.nix
    ../../modules/nixos/sshd.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/systemd-boot.nix
    ../../modules/nixos/virtualbox.nix
    ../../modules/nixos/wayland.nix
    ../../modules/nixos/x11.nix
  ];

  boot = {
    cleanTmpDir = true;
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "udev.log_priority=3" ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
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
  systemd.extraConfig = "DefaultTimeoutStopSec=30s";

  # Delete old logs
  services.journald.extraConfig = "MaxRetentionSec=14day";

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      narinfo-cache-positive-ttl = 86400
      auto-optimise-store = true
      repeat = 0
    '';

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
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

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
  };

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
