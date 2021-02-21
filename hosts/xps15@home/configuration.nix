{ config, pkgs, inputs, credentials, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../xps15/configuration.nix
  ];

  modules = {
    libreoffice.enable = true;
  };

  networking.hostName = "nixos";

  swapDevices = [ { device = "/dev/vg00/swap"; } ];
  fileSystems."/home" = {
    device = "/dev/vg00/home";
    fsType = "ext4";
  };
  fileSystems."/data" = {
    device = "/dev/vg00/data";
    fsType = "ext4";
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

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  # hardware.steam-hardware.enable = true;

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
