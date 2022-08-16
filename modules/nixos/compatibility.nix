{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.compatibility;
in {
  options.modules.compatibility = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.lib64 = ''
      # [ -d /lib64 ] || mkdir /lib64
      # rm -f /lib64/ld-linux-x86-64.so.2
      # ln -s ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
    '';

    environment.systemPackages = with pkgs; [
      steam-run
      (callPackage ../../pkgs/shell/fhs-shell {})
    ];
  };
}
