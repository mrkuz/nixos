{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [
    ../../profiles/hosts/minimal-nix.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packagesFor pkgs.linux-cros;
    initrd = {
      availableKernelModules = lib.mkForce [ ];
      kernelModules = lib.mkForce [ ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  environment.noXlibs = false;
  environment.systemPackages = with pkgs; [
    sommelier
    weston
  ];

  users = {
    mutableUsers = false;
    users = {
      root = {
        password = "root";
      };
    };
  };
}
