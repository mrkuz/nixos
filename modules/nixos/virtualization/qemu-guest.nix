{ config, lib, pkgs, sources, nixpkgs, modules, vars, profilesPath, ... }:

with lib;
let
  cfg = config.modules.qemuGuest;

  qemuConfig = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
    system = vars.currentSystem;
    specialArgs.profilesPath = profilesPath;
    modules = modules ++ [
      "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
      {
        virtualisation = {
          bootLoaderDevice = "/dev/vda";
          diskImage = null;
          # writableStore = false;
          sharedDirectories = lib.mkForce {
            nix-store = {
              source = builtins.storeDir;
              target = "/nix/store";
            };
          };
        };
      }
    ];
  }).config;

  startScriptWithGraphics = pkgs.writeShellScriptBin "start-vm" ''
    ${pkgs.qemu_kvm}/bin/qemu-kvm \
        -enable-kvm -cpu host \
        -m ${toString qemuConfig.virtualisation.memorySize} \
        -smp ${toString qemuConfig.virtualisation.cores} \
        -initrd ${qemuConfig.system.build.toplevel}/initrd \
        -kernel ${qemuConfig.system.build.toplevel}/kernel \
        -append "init=${qemuConfig.system.build.toplevel}/init" \
        -nodefaults -no-user-config \
        -fsdev local,id=nix-store,path=/nix/store,security_model=none -device virtio-9p-pci,fsdev=nix-store,mount_tag=nix-store \
        -netdev tap,id=tap0,ifname=tap0,script=no,downscript=no -device virtio-net-pci,netdev=tap0 \
        -display sdl,gl=on \
        -device virtio-vga-gl \
        -device virtio-rng-pci \
        -device virtio-keyboard-pci \
        -device virtio-mouse-pci
  '';

  startScript = pkgs.writeShellScriptBin "start-vm" ''
    ${pkgs.qemu_kvm}/bin/qemu-kvm -M microvm \
        -enable-kvm -cpu host \
        -m ${toString qemuConfig.virtualisation.memorySize} \
        -smp ${toString qemuConfig.virtualisation.cores} \
        -initrd ${qemuConfig.system.build.toplevel}/initrd \
        -kernel ${qemuConfig.system.build.toplevel}/kernel \
        -append "init=${qemuConfig.system.build.toplevel}/init console=ttyS0 " \
        -nodefaults -no-user-config -nographic \
        -serial stdio \
        -fsdev local,id=nix-store,path=/nix/store,security_model=none \
        -device virtio-9p-device,fsdev=nix-store,mount_tag=nix-store \
        -netdev tap,id=tap0,ifname=tap0,script=no,downscript=no \
        -device virtio-net-device,netdev=tap0 \
        -device virtio-rng-device
  '';

in
{
  options.modules.qemuGuest = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    graphics = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
        kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
      };
    };

    system.build.qemuRun = if cfg.graphics then startScriptWithGraphics else startScript;
  };
}
