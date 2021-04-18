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

  systemd.network = {
    enable = true;
    networks = {
      "01-nat" = {
        matchConfig = {
	        Name = "enp0s3";
	      };
	      DHCP = "yes";
      };
      "02-host-only" = {
        matchConfig = {
	        Name = "enp0s8";
	      };
        address = [
          "192.168.56.101/24"
        ];
      };
    };
  };

  networking = {
    hostName = "virtualbox";
    dhcpcd.enable = false;
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
    # avahi.enable = true;
    basePackages.enable = true;
    commandNotFound.enable = true;
    compatibility.enable = true;
    # docker.enable = true;
    emacs.enable = true;
    # gnome3.enable = true;
    # grubEfi.enable true;
    # kvm.enable = true;
    # libreoffice.enable = true;
    # nvidia.enable = true;
    # opengl.enable = true;
    # pipewire.enable = true;
    resolved.enable = true;
    # virtualbox.enable = true;
    # wayland.enable = true;
    # x11.enable = true;
  };
}
