{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ../../profiles/hosts/minimal.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packagesFor pkgs.linux-cros;
    initrd = {
      availableKernelModules = lib.mkForce [ ];
      kernelModules = lib.mkForce [ ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  environment.noXlibs = false;
  environment.systemPackages = with pkgs; [
    socat
    sommelier
    waypipe
    weston
    xorg.xeyes
    xwayland
  ];

  networking.dhcpcd.enable = false;
  systemd.network = {
    enable = true;
    networks = {
      "nat" = {
        matchConfig = {
          Name = "e*";
        };
        address = [
          "192.168.77.2/24"
        ];
        DHCP = "no";
        gateway = [ "192.168.77.1" ];
        dns = [ "8.8.8.8" ];
        extraConfig = ''
          LLDP=false
          EmitLLDP=false
        '';
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
