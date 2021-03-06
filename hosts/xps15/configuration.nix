{ config, pkgs, credentials, ... }:

{
  imports = [
    ../_all/configuration.nix
  ];

  modules = {
    android.enable = true;
    # ansible.enable = true;
    avahi.enable = true;
    basePackages.enable = true;
    commandNotFound.enable = true;
    compatibility.enable = true;
    docker.enable = true;
    emacs.enable = true;
    gnome3.enable = true;
    grubEfi.enable = true;
    # kvm.enable = true;
    # libreoffice.enable = true;
    nvidia.enable = true;
    opengl.enable = true;
    # pipewire.enable = true;
    resolved.enable = true;
    virtualbox.enable = true;
    wayland.enable = true;
    x11.enable = true;
  };

  # Use cgroups v1
  systemd.enableUnifiedCgroupHierarchy = false;

  systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

  hardware.opengl = {
    extraPackages = with pkgs; [
      vaapiIntel
    ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.printing = {
    enable = true;
  };

  services.smartd.enable = true;
  services.thermald.enable = true;

  # virtualisation.libvirtd.enable = true;
}
