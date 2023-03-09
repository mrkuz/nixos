{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [
    ../../profiles/hosts/minimal-nix.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packagesFor pkgs.linux-cros;

  #virtualisation.useNixStoreImage = true;
  #virtualisation.writableStore = false;

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
