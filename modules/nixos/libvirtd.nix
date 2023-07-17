{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.libvirtd;
in
{
  options.modules.libvirtd = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
        };
        runAsRoot = false;
      };
    };

    environment.systemPackages = with pkgs; [
      # guestfs-tools
      qemu_kvm
      qemu-utils
      virt-manager
    ];
  };
}
