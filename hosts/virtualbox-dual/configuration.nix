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
    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      luks.devices.crypt = {
        device = "/dev/sda2";
        keyFile = "/etc/luks/boot.keyfile";
      };
      secrets = {
        "/etc/luks/boot.keyfile" = null;
      };
      systemd.enable = true;
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
