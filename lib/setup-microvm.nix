{ self, nixpkgs, inputs }:

{ name, system }:

(nixpkgs.lib.nixosSystem {
  inherit system;
  modules = self.utils.mkNixOSModules {
    inherit name system;
    extraModules = [
      (import "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix")
      (../hosts + "/${name}" + /configuration.nix)
      ({ config, lib, pkgs, sources, ... }:
        let
          startScript = pkgs.writeShellScriptBin "start-vm" ''

            ${pkgs.qemu_kvm}/bin/qemu-kvm -M microvm \
                -enable-kvm -cpu host \
                -m ${toString config.virtualisation.memorySize} \
                -smp ${toString config.virtualisation.cores} \
                -initrd ${config.system.build.toplevel}/initrd \
                -kernel ${config.system.build.toplevel}/kernel \
                -append "init=${config.system.build.toplevel}/init console=ttyS0 " \
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
          virtualisation = {
            diskImage = null;
            sharedDirectories = lib.mkForce {
              nix-store = {
                source = builtins.storeDir;
                target = "/nix/store";
              };
            };
          };

          system.build.microvm = startScript;
        })
    ];
  };
}).config.system.build.microvm
