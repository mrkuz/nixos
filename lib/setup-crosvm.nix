{ self, nixpkgs, inputs }:

{ name, system }:

(nixpkgs.lib.nixosSystem {
  inherit system;
  modules = self.utils.mkNixOSModules {
    inherit name system;
    extraModules = [
      (../hosts + "/${name}" + /configuration.nix)
      ({ config, lib, pkgs, sources, ... }:
        let
          diskImageConfig = config // {
            boot = {
              initrd.enable = false;
              kernel.enable = false;
              loader.grub.enable = false;
            };
          };

          diskImage = self.utils.mkImage rec {
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
          system.build.crosvm = startScript;
        })
    ];
  };
}).config.system.build.crosvm
