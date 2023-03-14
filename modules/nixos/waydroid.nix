{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.waydroid;

  waydroid-ui = pkgs.writeShellScriptBin "waydroid-ui" ''
    export WAYLAND_DISPLAY=wayland-0
    ${pkgs.weston}/bin/weston -Swayland-1 --width=600 --height=1000 --shell="kiosk-shell.so" &
    WESTON_PID=$!

    export WAYLAND_DISPLAY=wayland-1
    ${pkgs.waydroid}/bin/waydroid show-full-ui &

    wait $WESTON_PID
    waydroid session stop
  '';
in
{
  options.modules.waydroid = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      waydroid.enable = true;
      lxd.enable = true;
    };

    environment.systemPackages = with pkgs; [
      waydroid-ui
      weston
    ];
  };
}
