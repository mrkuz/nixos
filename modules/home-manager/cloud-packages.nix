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
    home.packages = [
      pkgs.google-cloud-sdk
      pkgs.kubernetes-helm
      pkgs.kubectl
      pkgs.kubetail
      pkgs.minikube
      pkgs.terraform
    ];
  };
}
