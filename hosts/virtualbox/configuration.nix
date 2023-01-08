{ config, pkgs, inputs, vars, credentials, ... }:

{
  imports = [
    ../_all/configuration.nix
  ];

  modules = {
    basePackages.enable = true;
    btrfs.enable = true;
    commandNotFound.enable = true;
    emacs.enable = true;
    resolved.enable = true;
    sshd.enable = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      luks.devices.crypt.device = "/dev/sda2";
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd:1" "noatime" ];
    };
    "/var" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=var" "compress=zstd:1" "noatime" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:1" "noatime" ];
    };
    "/data" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=data" "compress=zstd:1" "noatime" ];
    };
  };

  swapDevices = [{ device = "/.swapfile"; }];

  networking = {
    hostName = "virtualbox";
    dhcpcd.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      "01-nat" = {
        matchConfig = {
          Name = "enp0s3";
        };
        DHCP = "yes";
        dns = [ "8.8.8.8" ];
      };
      "02-host-only" = {
        matchConfig = {
          Name = "enp0s8";
        };
        address = [
          "192.168.56.101/24"
        ];
      };
    };
  };

  virtualisation.virtualbox.guest = {
    enable = true;
    x11 = true;
  };

  users = {
    groups.markus.gid = 1000;
    users = {
      markus = {
        uid = 1000;
        description = "Markus";
        isNormalUser = true;
        group = "markus";
        extraGroups = [ "wheel" ];
        password = credentials.markus.password;
        shell = pkgs.fish;
      };
    };
  };

  home-manager.users.markus = ../../users/markus/home.nix;
}
