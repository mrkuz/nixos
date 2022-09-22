{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.cloudTools;
in
{
  options.modules.cloudTools = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      google-cloud-sdk
      kubernetes-helm
      kubectl
      kubetail
      minikube
      terraform
    ];
  };
}
