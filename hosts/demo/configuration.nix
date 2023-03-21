{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ../../profiles/hosts/default.nix
  ];

  modules = {
    basePackages.enable = true;
    btrfs.enable = true;
    commandNotFound.enable = true;
    resolved.enable = true;
    sshd.enable = true;
  };

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "xhci_pci" "sd_mod" "sr_mod" "virtio_pci" "virtio_blk" ];
      luks.devices.crypt.device = "/dev/sda2";
    };
    kernelParams = [ "nomodeset" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
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
    hostName = "demo";
    dhcpcd.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      "nat" = {
        matchConfig = {
          Name = "enp*";
        };
        DHCP = "yes";
        dns = [ "8.8.8.8" ];
      };
    };
  };

  users = {
    groups.user.gid = 1000;
    users = {
      user = {
        uid = 1000;
        description = "User";
        isNormalUser = true;
        group = "user";
        extraGroups = [ "wheel" ];
        password = "user";
        shell = pkgs.fish;
      };
    };
  };

  home-manager.users.user = ../../users/user/home.nix;
}
