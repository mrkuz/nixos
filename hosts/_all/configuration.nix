{ config, pkgs, rev, ... }:

{
  imports = [
    ../../modules/nixos/android.nix
    ../../modules/nixos/ansible.nix
    ../../modules/nixos/avahi.nix
    ../../modules/nixos/base-packages.nix
    ../../modules/nixos/command-not-found.nix
    ../../modules/nixos/compatibility.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/emacs.nix
    ../../modules/nixos/gnome3.nix
    ../../modules/nixos/grub-efi.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/opengl.nix
    ../../modules/nixos/resolved.nix
    ../../modules/nixos/virtualbox.nix
    ../../modules/nixos/wayland.nix
    ../../modules/nixos/x11.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.useDHCP = false;
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  # Speed up boot
  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.dhcpcd.wait = "background";

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
