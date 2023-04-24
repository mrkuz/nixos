{ config, lib, pkgs, sources, profilesPath, ... }:

{
  imports = [
    "${profilesPath}/hosts/minimal.nix"
  ];

  modules = {
    nix.enable = true;
    qemuGuest.enable = true;
  };

  networking.dhcpcd.enable = false;
  systemd.network = {
    enable = true;
    networks = {
      "nat" = {
        matchConfig = {
          Name = "eth*";
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
