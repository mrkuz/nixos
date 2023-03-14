{ config, lib, pkgs, sources, ... }:

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

  networking.dhcpcd.enable = false;
  systemd.network = {
    enable = true;
    networks = {
      "nat" = {
        matchConfig = {
          Name = "eth0";
        };
        address = [
          "192.168.77.2/24"
        ];
        DHCP = "no";
        gateway = [ "192.168.77.1" ];
        dns = [ "8.8.8.8" ];
      };
    };
  };

  users = {
    groups.user.gid = 1000;
    mutableUsers = false;
    users = {
      root = {
        password = "root";
      };
      user = {
        uid = 1000;
        description = "User";
        isNormalUser = true;
        group = "user";
        extraGroups = [ "wheel" ];
        password = "user";
      };
    };
  };
}
