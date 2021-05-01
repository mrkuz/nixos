{ config, pkgs, credentials, ... }:

{
  imports = [
    ../_all/configuration.nix
  ];

  modules = {
    android.enable = true;
    avahi.enable = true;
    basePackages.enable = true;
    commandNotFound.enable = true;
    compatibility.enable = true;
    desktop.enable = true;
    docker.enable = true;
    emacs.enable = true;
    gnome3.enable = true;
    grubEfi.enable = true;
    nvidia.enable = true;
    opengl.enable = true;
    resolved.enable = true;
    virtualbox.enable = true;
    wayland.enable = true;
    x11.enable = true;
  };

  # Use cgroups v1
  systemd.enableUnifiedCgroupHierarchy = false;

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];
  # virtualisation.libvirtd.enable = true;
}
