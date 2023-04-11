{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.waypipe;
in
{
  options.modules.waypipe = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    vsockPort = mkOption {
      default = 4321;
      type = types.ints.unsigned;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      socat
      waypipe
    ];

    systemd.user.services.waypipe = {
      Unit = {
        Description = "waypipe";
      };

      Service = {
        ExecStart = "${pkgs.waypipe}/bin/waypipe --socket /run/user/%U/waypipe.sock client";
        Restart = "always";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.waypipe-vsock = {
      Unit = {
        Description = "waypipe - vsock";
        After = "waypipe.service";
      };

      Service = {
        ExecStart = "${pkgs.socat}/bin/socat VSOCK-LISTEN:${builtins.toString cfg.vsockPort} unix-connect:/run/user/%U/waypipe.sock";
        Restart = "always";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
