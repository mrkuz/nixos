{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/F29C-27AB";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
    fsType = "btrfs";
    options = [ "subvol=var" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
    fsType = "btrfs";
    options = [ "subvol=data" "compress=zstd:1" "noatime" ];
  };
}
