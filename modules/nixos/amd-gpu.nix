{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.amdGpu;
in
{
  options.modules.amdGpu = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.opengl = with pkgs; {
      extraPackages = [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      extraPackages32 = [ driversi686Linux.amdvlk ];
    };

    services.xserver = {
      videoDrivers = [ "amdgpu" ];
    };

    environment.variables = {
      "LIBVA_DRIVER_NAME" = "radeonsi";
      "VDPAU_DRIVER" = "va_gl";
      # "VDPAU_DRIVER" = "radeonsi";
    };
  };
}
