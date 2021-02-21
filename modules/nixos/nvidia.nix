{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.nvidia;

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in {
  options.modules.nvidia = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };

    hardware.nvidia = {
      nvidiaPersistenced = false;
      modesetting.enable = true;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    hardware.opengl.driSupport32Bit = mkIf config.modules.docker.enable true;
    # virtualisation.docker.enableNvidia = mkIf config.modules.docker.enable true;
    services.xserver.displayManager.gdm.nvidiaWayland = mkIf config.modules.gnome3.enable true;

    environment.systemPackages = with pkgs; [
      nvidia-offload
    ];
  };
}
