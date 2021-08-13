{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.cloudPackages;
in {
  options.modules.cloudPackages = {
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
