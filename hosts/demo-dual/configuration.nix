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
      luks.devices.crypt = {
        device = "/dev/sda2";
        keyFile = "/etc/luks/boot.keyfile";
      };
      secrets = {
        "/etc/luks/boot.keyfile" = null;
      };
      systemd.enable = true;
    };
    kernelParams = [ "nomodeset" ];
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        extraEntries = ''
          menuentry "Ubuntu" {
            set root=(hd0,1)
            chainloader /EFI/ubuntu/grubx64.efi
          }
        '';
      };
      systemd-boot.enable = false;
      timeout = 3;
    };
  };

  fileSystems = {
    "/boot/efi" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ "subvol=@nix/root" "compress=zstd:1" "noatime" ];
    };
    "/var" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ "subvol=@nix/var" "compress=zstd:1" "noatime" ];
    };
    "/nix" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ "subvol=@nix/nix" "compress=zstd:1" "noatime" ];
    };
    "/home" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ "subvol=@nix/home" "compress=zstd:1" "noatime" ];
    };
    "/data" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ "subvol=@nix/data" "compress=zstd:1" "noatime" ];
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
