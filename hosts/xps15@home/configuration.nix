{ config, pkgs, inputs, vars, credentials, ... }:

{
  imports = [
    ../xps15/configuration.nix
  ];

  modules = {
    btrfs.enable = true;
    buildEssentials.enable = true;
    libreoffice.enable = true;
    snapper.enable = true;
    systemdBoot.enable = true;
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/F29C-27AB";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd:1" "noatime" ];
    };
    "/var" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=var" "compress=zstd:1" "noatime" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:1" "noatime" ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=data" "compress=zstd:1" "noatime" ];
    };
  };

  swapDevices = [{ device = "/.swapfile"; }];

  networking.hostName = "nixos";

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.openssh.settings.PasswordAuthentication = false;
  # services.teamviewer.enable = true;

  users = {
    groups = {
      markus.gid = 1000;
      enesa.gid = 1001;
      malik.gid = 1002;
    };
    users = {
      markus = {
        uid = 1000;
        description = "Markus";
        isNormalUser = true;
        group = "markus";
        extraGroups = [ "wheel" "adbusers" "docker" "libvirtd" "lp" "scanner" "vboxusers" ];
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
      malik = {
        uid = 1002;
        description = "Malik";
        isNormalUser = true;
        group = "malik";
        extraGroups = [ "lp" "scanner" ];
        hashedPassword = credentials.malik.hashedPassword;
        shell = pkgs.bash;
      };
    };
  };

  home-manager.users.markus = ./. + "/../../users/markus@home/home.nix";
  home-manager.users.enesa = ../../users/enesa/home.nix;
  home-manager.users.malik = ../../users/malik/home.nix;
}
