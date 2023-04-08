{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ../../profiles/hosts/default.nix
    ../../profiles/hosts/austria.nix
  ];

  modules = {
    # avahi.enable = true;
    amdGpu.enable = true;
    basePackages.enable = true;
    commandNotFound.enable = true;
    # desktop.enable = true;
    # docker.enable = true;
    fonts.enable = true;
    gnome.enable = true;
    kvm.enable = true;
    # lxd.enable = true;
    # libreoffice.enable = true;
    opengl.enable = true;
    pipewire.enable = true;
    podman.enable = true;
    # resolved.enable = true;
    systemdBoot.enable = true;
    # tap = {
    #   enable = true;
    #   owner = "markus";
    #   externalInterface = "wlp5s0";
    # };
    # wayland.enable = true;
    x11.enable = true;
  };

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "amd_pstate=passive" ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/" = {
      device = "none";
      fsType = "tmpfs";
    };
    "/etc" = {
      device = "/dev/pool/host.etc";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/var" = {
      device = "/dev/pool/host.var";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/nix" = {
      device = "/dev/pool/shared.nix";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/home" = {
      device = "/dev/pool/shared.home";
      fsType = "ext4";
      options = [ "noatime" ];
      # Ensures that SSH private key is available for decryption
      neededForBoot = true;
    };
    "/data" = {
      device = "/dev/pool/shared.data";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/data/overlays/home/mnt" = {
      fsType = "overlay";
      device = "overlay";
      options = [
        "lowerdir=/home"
        "upperdir=/data/overlays/home/upper"
        "workdir=/data/overlays/home/work"
        "x-systemd.requires-mounts-for=/home"
      ];
    };
  };

  swapDevices = [{ device = "/dev/pool/host.swap"; }];

  networking.hostName = "nixos";

  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # hardware.sane = {
  #   enable = true;
  #   extraBackends = [ pkgs.hplipWithPlugin ];
  # };

  services = {
    fstrim.enable = true;
    printing = {
      enable = true;
      # drivers = [ pkgs.hplipWithPlugin ];
    };
    tuptime.enable = true;
  };

  age.secrets = {
    markus.file = ./secrets/markus.age;
    enesa.file = ./secrets/enesa.age;
    malik.file = ./secrets/malik.age;
  };

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
        extraGroups = [ "wheel" "adbusers" "disk" "docker" "libvirtd" "lp" "lxd" "podman" "scanner" "vboxusers" ];
        passwordFile = config.age.secrets.markus.path;
        shell = pkgs.fish;
      };
      enesa = {
        uid = 1001;
        description = "Enesa";
        isNormalUser = true;
        group = "enesa";
        extraGroups = [ "lp" "scanner" ];
        passwordFile = config.age.secrets.enesa.path;
        shell = pkgs.bash;
      };
      malik = {
        uid = 1002;
        description = "Malik";
        isNormalUser = true;
        group = "malik";
        extraGroups = [ "lp" "scanner" ];
        passwordFile = config.age.secrets.malik.path;
        shell = pkgs.bash;
      };
    };
  };

  home-manager.users.markus = ./. + "/../../users/markus@home/home.nix";
  home-manager.users.enesa = ../../users/enesa/home.nix;
  home-manager.users.malik = ../../users/malik/home.nix;
}
