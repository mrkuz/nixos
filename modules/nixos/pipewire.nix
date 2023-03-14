{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.pipewire;
in
{
  options.modules.pipewire = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = mkForce false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
