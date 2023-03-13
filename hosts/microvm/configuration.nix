{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [
    ../../profiles/hosts/minimal-nix.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
      kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
    };
  };

  systemd.network = {
    enable = true;
    networks = {
      "01-nat" = {
        matchConfig = {
          Name = "eth0";
        };
        DHCP = "yes";
        dns = [ "8.8.8.8" ];
      };
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        password = "root";
      };
    };
  };
}
