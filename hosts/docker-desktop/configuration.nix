{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [
    ../docker/configuration.nix
  ];

  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;
    desktopManager.xfce.enable = true;
  };

  # port: 3389
  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
  };

  # Override defaults from nixos/modules/profiles/docker-container.nix
  environment.noXlibs = false;

  users = {
    groups.user.gid = 1000;
    users = {
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
