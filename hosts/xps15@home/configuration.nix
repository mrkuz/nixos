{ config, pkgs, inputs, vars, credentials, ... }:

{
  imports = [
    ../_all/configuration.nix
  ];

  modules = {
    android.enable = true;
    basePackages.enable = true;
    btrfs.enable = true;
    commandNotFound.enable = true;
    compatibility.enable = true;
    desktop.enable = true;
    docker.enable = true;
    emacs.enable = true;
    fonts.enable = true;
    gnome.enable = true;
    libreoffice.enable = true;
    nvidia.enable = true;
    opengl.enable = true;
    pipewire.enable = true;
    resolved.enable = true;
    snapper.enable = true;
    systemdBoot.enable = true;
    virtualbox.enable = true;
    wayland.enable = true;
    x11.enable = true;
  };

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
      kernelModules = [ "i915" ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/F29C-27AB";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd:1" "noatime" ];
    };
    "/var" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=var" "compress=zstd:1" "noatime" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:1" "noatime" ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/7ff654ca-c480-48aa-ad10-835c44ecb0e5";
      fsType = "btrfs";
      options = [ "subvol=data" "compress=zstd:1" "noatime" ];
    };
  };

  swapDevices = [{ device = "/.swapfile"; }];

  networking.hostName = "nixos";

  powerManagement.cpuFreqGovernor = "powersave";
  hardware.enableRedistributableFirmware = true;

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

  sound.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  # systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

  services = {
    fstrim.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = true;
    smartd.enable = true;
    thermald.enable = true;
    tuptime.enable = true;
  };

  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.openssh.settings.PasswordAuthentication = false;
  # services.teamviewer.enable = true;

  users = {
    groups = {
      markus.gid = 1000;
      enesa.gid = 1001;
      malik.gid = 1002;
    };
    users = {
      markus = {
        uid = 1000;
        description = "Markus";
        isNormalUser = true;
        group = "markus";
        extraGroups = [ "wheel" "adbusers" "docker" "libvirtd" "lp" "scanner" "vboxusers" ];
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
      malik = {
        uid = 1002;
        description = "Malik";
        isNormalUser = true;
        group = "malik";
        extraGroups = [ "lp" "scanner" ];
        hashedPassword = credentials.malik.hashedPassword;
        shell = pkgs.bash;
      };
    };
  };

  home-manager.users.markus = ./. + "/../../users/markus@home/home.nix";
  home-manager.users.enesa = ../../users/enesa/home.nix;
  home-manager.users.malik = ../../users/malik/home.nix;
}
