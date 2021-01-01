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
      [ -d /lib64 ] || mkdir /lib64
      [ -L /lib64/ld-linux-x86-64.so.2 ] || ln -sf ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
    '';
  };
}
