{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@nix/root" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/var" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@nix/var" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/nix" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@nix/nix" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@nix/home" "compress=zstd:1" "noatime" ];
  };
  fileSystems."/data" = {
    device = "/dev/mapper/crypt";
    fsType = "btrfs";
    options = [ "subvol=@nix/data" "compress=zstd:1" "noatime" ];
  };
}
