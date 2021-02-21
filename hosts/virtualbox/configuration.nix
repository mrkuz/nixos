{ config, pkgs, inputs, credentials, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../_all/configuration.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "virtualbox";
    interfaces = {
      enp0s3.useDHCP = true;
      enp0s8.ipv4.addresses = [ {
        address = "192.168.56.101";
        prefixLength = 24;
      } ];
    };
  };

  services.openssh = {
    enable = true;
  };

  users = {
    groups.user.gid = 1000;
    users = {
      user = {
        uid = 1000;
        description = "User";
        isNormalUser = true;
        group = "user";
        extraGroups = [ "wheel" ];
        password = credentials.user.password;
        shell = pkgs.fish;
      };
    };
  };

  home-manager.users.user = import ../../users/user/home.nix {
    inherit pkgs;
    inherit inputs;
  };

  modules = {
    # android.enable = true;
    # ansible.enable = true;
    # avahi.enable = true;
    basePackages.enable = true;
    commandNotFound.enable = true;
    compatibility.enable = true;
    # docker.enable = true;
    emacs.enable = true;
    # gnome3.enable = true;
    # grubEfi.enable true;
    # nvidia.enable = true;
    # opengl.enable = true;
    # resolved.enable = true;
    # virtualbox.enable = true;
    # wayland.enable = true;
    # x11.enable = true;
  };
}
