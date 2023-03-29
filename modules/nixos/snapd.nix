{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.snapd;
  snapd-start = pkgs.writeShellScriptBin "snapd-start" ''
    if [[ $EUID -ne 0 ]]; then
      echo "This script must be run as root"
      exit 1
    fi

    DIRS="dbus-1 systemd/system udev/rules.d"

    for i in $DIRS; do
        mkdir -p /var/etc/$i;
        mkdir -p /var/etc/$i.work;
        target=$(readlink "/etc/static/$i")
        mount -t overlay overlay -o lowerdir=$target,upperdir=/var/etc/$i,workdir=/var/etc/$i.work $target
    done

    systemctl start snapd.socket
    systemctl start snapd.service
  '';

  snapd-stop = pkgs.writeShellScriptBin "snapd-stop" ''
    if [[ $EUID -ne 0 ]]; then
      echo "This script must be run as root"
      exit 1
    fi

    DIRS="dbus-1 systemd/system udev/rules.d"

    for i in $DIRS; do
        target=$(readlink "/etc/static/$i")
        if findmnt $target; then
            umount $target;
        fi
    done

    systemctl stop snapd.socket
    systemctl stop snapd.service
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
    environment.systemPackages = [ pkgs.snapd pkgs.squashfsTools snapd-start snapd-stop ];
    security.apparmor.packages = [ pkgs.snapd ];
    services.dbus.packages = [ pkgs.snapd ];
    systemd.packages = [ pkgs.snapd ];
    systemd.tmpfiles.packages = [ pkgs.snapd ];

    # No autostart for now - use snapd-start/snapd-stop instead
    # systemd.services.snapd.wantedBy = [ "multi-user.target" ];
    # systemd.sockets.snapd.wantedBy = [ "sockets.target" ];

    security.wrappers.snapd-confine = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.snapd}/lib/snapd/snap-confine.unwrapped";
    };

    environment.etc."default/snapd".text = ''
      PATH=/run/current-system/sw/bin
    '';
  };
}
