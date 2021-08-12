{ config, pkgs, credentials, ... }:

{
  imports = [
    ../_all/configuration.nix
  ];

  modules = {
    android.enable = true;
    basePackages.enable = true;
    commandNotFound.enable = true;
    compatibility.enable = true;
    desktop.enable = true;
    docker.enable = true;
    emacs.enable = true;
    gnome.enable = true;
    grubEfi.enable = true;
    nvidia.enable = true;
    opengl.enable = true;
    resolved.enable = true;
    virtualbox.enable = true;
    wayland.enable = true;
    x11.enable = true;
  };

  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];

  hardware.nvidia = {
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.opengl.extraPackages = [
    pkgs.intel-media-driver
    pkgs.vaapiIntel
  ];

  # Use cgroups v1
  systemd.enableUnifiedCgroupHierarchy = false;
  # systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

  services = {
    fstrim.enable = true;
    haveged.enable = true;
    power-profiles-daemon.enable = false;
    smartd.enable = true;
    thermald.enable = true;
    tlp.enable = true;
    tuptime.enable = true;
  };

  # virtualisation.libvirtd.enable = true;
}
