{ config, pkgs, inputs, credentials, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../xps15/configuration.nix
  ];

  modules = {
    btrfs.enable = true;
    libreoffice.enable = true;
    pipewire.enable = true;
    sshd.enable = true;
    systemdBoot.enable = true;
  };

  networking.hostName = "nixos";

  swapDevices = [ { device = "/.swapfile"; } ];
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
  fileSystems."/data/overlay/home/mnt" = {
    fsType = "overlay";
    device = "overlay";
    options = [
      "lowerdir=/home"
      "upperdir=/data/overlay/home/rw"
      "workdir=/data/overlay/home/work"
      "x-systemd.requires-mounts-for=/home"
    ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  # hardware.steam-hardware.enable = true;

  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.openssh.passwordAuthentication = false;

  nixpkgs.config.kodi.enableInputStreamAdaptive = true;
  environment.systemPackages = with pkgs; [
    thunderbird
    kodi
  ];

  users = {
    groups.markus.gid = 1000;
    groups.enesa.gid = 1001;
    users = {
      markus = {
        uid = 1000;
        description = "Markus";
        isNormalUser = true;
        group = "markus";
        extraGroups = [ "wheel" "adbusers" "docker" "libvirtd"  "lp" "scanner" "vboxusers" ];
        hashedPassword = credentials."markus@home".hashedPassword;
        shell = pkgs.fish;
      };

      enesa = {
        uid = 1001;
        description = "Enesa";
        isNormalUser = true;
        group = "enesa";
        extraGroups = [ "lp" "scanner" ];
        hashedPassword = credentials.enesa.hashedPassword;
        shell = pkgs.bash;
      };
    };
  };

  home-manager.users.markus = import (./. + "/../../users/markus@home/home.nix") {
    inherit pkgs;
    inherit inputs;
  };
}
