{ config, pkgs, inputs, credentials, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../xps15/configuration.nix
  ];

  modules = {
    btrfs.enable = true;
    buildPackages.enable = true;
    libreoffice.enable = true;
    kodi.enable = true;
    pipewire.enable = true;
    sshd.enable = true;
    systemdBoot.enable = true;
  };

  networking.hostName = "nixos";

  swapDevices = [ { device = "/.swapfile"; } ];

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  # hardware.steam-hardware.enable = true;

  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.openssh.passwordAuthentication = false;

  environment.systemPackages = with pkgs; [
    thunderbird
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

  home-manager.users.enesa = import (./. + "/../../users/enesa/home.nix") {
    inherit pkgs;
    inherit inputs;
  };
}
