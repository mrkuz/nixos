{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.opengl;
in {
  options.modules.opengl = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    environment.systemPackages = with pkgs; [
      libva-utils
      glxinfo
      vdpauinfo
      vulkan-tools
    ];
  };
}
