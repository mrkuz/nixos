{ config, lib, pkgs, ... }:

with lib;
let
 cfg = config.modules.sway;
in {
  options.modules.sway = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures = {
        gtk = true;
      };
      extraPackages = with pkgs; [ swaybg swayidle swaylock ];
      extraOptions = mkIf config.modules.nvidia.enable [
        "--unsupported-gpu"
        "--my-next-gpu-wont-be-nvidia"
      ];
    };

    environment.systemPackages = with pkgs; [
      alacritty
      dmenu
    ];
  };
}
