{ config, pkgs, inputs, credentials, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../xps15/configuration.nix
  ];

  networking = {
    hostName = "nixos";
    extraHosts = "172.19.96.110 trow.kube-public";
    firewall.allowedTCPPorts = [ 8888 ];
  };

  swapDevices = [ { device = "/dev/vg00/swap"; } ];
  fileSystems."/home" = {
    device = "/dev/vg00/home";
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

  virtualisation = {
    docker.extraOptions = "--insecure-registry trow.kube-public:31000";
    docker.listenOptions = [ "/run/docker.sock" "0.0.0.0:2375" ];
  };

  users = {
    groups.markus.gid = 1000;
    users = {
      markus = {
        uid = 1000;
        description = "Markus";
        isNormalUser = true;
        group = "markus";
        extraGroups = [ "wheel" "adbusers" "docker" "libvirtd"  "lp" "scanner" "vboxusers" ];
        hashedPassword = credentials."markus@work".hashedPassword;
        shell = pkgs.fish;
      };
    };
  };

  home-manager.users.markus = import (./. + "/../../users/markus@work/home.nix") {
    inherit pkgs;
    inherit inputs;
  };
}
