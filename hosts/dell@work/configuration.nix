{ config, pkgs, inputs, vars, credentials, ... }:

{
  imports = [
    ../_all/configuration.nix
    ./hardware-configuration.nix
  ];

  modules = {
    basePackages.enable = true;
    btrfs.enable = true;
    buildEssentials.enable = true;
    commandNotFound.enable = true;
    desktop.enable = true;
    docker.enable = true;
    emacs.enable = true;
    fonts.enable = true;
    gnome.enable = true;
    libreoffice.enable = true;
    opengl.enable = true;
    pipewire.enable = true;
    resolved.enable = true;
    snapper.enable = true;
    wayland.enable = true;
    x11.enable = true;
  };

  # TODO: kernel modules

  boot.loader = {
    efi.canTouchEfiVariables = false;
    systemd-boot = {
      enable = true;
      editor = true;
      configurationLimit = 3;
    };
    timeout = 3;
  };

  networking.hostName = "nixos";

  swapDevices = [{ device = "/.swapfile"; }];

  powerManagement.cpuFreqGovernor = "powersave";

  # TODO: graphic card, opengl

  sound.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services = {
    fstrim.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = true;
    smartd.enable = true;
    thermald.enable = true;
    tuptime.enable = true;
  };

  users = {
    groups = {
      markus.gid = 1000;
    };
    users = {
      markus = {
        uid = 1000;
        description = "Markus";
        isNormalUser = true;
        group = "markus";
        extraGroups = [ "wheel" "adbusers" "docker" "libvirtd" "lp" "scanner" "vboxusers" ];
        hashedPassword = credentials."markus@work".hashedPassword;
        shell = pkgs.fish;
      };
    };
  };

  home-manager.users.markus = ./. + "/../../users/markus@work/home.nix";
}
