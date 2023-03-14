{ config, lib, pkgs, sources, ... }:

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

in
{
  options.modules.nvidia = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      nvidiaPersistenced = true;
      modesetting.enable = true;
      prime.offload.enable = true;
    };

    hardware.opengl.driSupport32Bit = mkIf config.modules.docker.enable true;

    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };
    # virtualisation.docker.enableNvidia = mkIf config.modules.docker.enable true;

    environment.systemPackages = with pkgs; [
      nvidia-offload
    ];
  };
}
