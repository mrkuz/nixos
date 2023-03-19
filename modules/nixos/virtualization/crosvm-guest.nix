{ config, lib, pkgs, sources, nixpkgs, ... }:

with lib;
let
  cfg = config.modules.crosvmGuest;
  mkImage = import "${nixpkgs}/nixos/lib/make-disk-image.nix";

  diskImageConfig = config // {
    boot = {
      initrd.enable = false;
      kernel.enable = false;
      loader.grub.enable = false;
    };
  };

  diskImage = mkImage rec {
    inherit lib pkgs;
    label = "nix-store";
    config = diskImageConfig;
    installBootLoader = false;
    copyChannel = false;
    additionalSpace = "0M";
    format = "qcow2";
    onlyNixStore = true;
  };

  startScript = pkgs.writeShellScriptBin "start-vm" ''
    ${pkgs.crosvm}/bin/crosvm run \
        --disable-sandbox \
        --wayland-sock /run/user/1000/wayland-0 \
        --mem 1024 \
        --cpus 2 \
        --disk "${diskImage}/nixos.qcow2" \
        --tap-name=tap0 \
        --initrd ${config.system.build.toplevel}/initrd \
        -p "init=${config.system.build.toplevel}/init console=ttyS0 " \
        ${config.system.build.toplevel}/kernel
  '';
in
{
  options.modules.crosvmGuest = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    boot.loader.grub.enable = false;

    fileSystems."/" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
    fileSystems."/nix/store" = {
      device = "/dev/disk/by-label/nix-store";
      fsType = "ext4";
      options = [ "ro" ];
    };

    system.build.crosvmRun = startScript;
  };
}
