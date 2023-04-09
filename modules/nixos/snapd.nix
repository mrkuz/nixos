{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.snapd;

  mountSquashfuse = pkgs.runCommandLocal "mount-squashfuse" { } ''
    mkdir -p $out/bin/
    ln -s ${pkgs.squashfuse}/bin/squashfuse "$out/bin/mount.fuse.squashfuse"
  '';
in
{
  options.modules.snapd = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    boot.initrd = {
      availableKernelModules = [ "overlay " ];
      kernelModules = [ "overlay " ];
    };

    environment.systemPackages = [ pkgs.snapd pkgs.squashfsTools pkgs.squashfuse mountSquashfuse ];
    services.dbus.packages = [ pkgs.snapd ];

    systemd = {
      packages = [ pkgs.snapd ];
      tmpfiles.packages = [ pkgs.snapd ];
      services.snapd.wantedBy = [ "multi-user.target" ];
      sockets.snapd.wantedBy = [ "sockets.target" ];
      tmpfiles.rules = [
        "L+  /bin/bash        -  -  -  -  ${pkgs.bash}/bin/bash"
        "L+  /usr/lib/locale  -  -  -  -  ${pkgs.glibc}/lib/locale"
        "L+  /snap            -  -  -  -  /var/lib/snapd/snap"
      ];
    };

    programs.nix-ld.enable = true;
    environment.etc."default/snapd".text = ''
      PATH=/run/current-system/sw/bin

      NIX_LD=${pkgs.glibc}/lib/ld-linux-x86-64.so.2
      NIX_LD_LIBRARY_PATH=/run/current-system/sw/share/nix-ld/lib
    '';

    security.wrappers.snapd-confine = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.snapd}/lib/snapd/snap-confine.unwrapped";
    };

    system.activationScripts.snapd.text = ''
      DIRS="dbus-1 systemd/system udev/rules.d"

      for i in $DIRS; do
        mkdir -p /var/etc/$i;
        mkdir -p /var/etc/$i.work;

        cat /proc/mounts | ${pkgs.gawk}/bin/awk -v source="/var/etc/$i" '$0~source{print $2}' | xargs -r umount

        target=$(readlink "/etc/static/$i")
        mount -t overlay overlay -o lowerdir=$target,upperdir=/var/etc/$i,workdir=/var/etc/$i.work $target
      done
    '';
  };
}
