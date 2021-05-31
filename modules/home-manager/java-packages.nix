{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.javaPackages;
in {
  options.modules.javaPackages = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eclipse-mat
      ((pkgs.gradleGen.override { java = jdk; }).gradle_latest)
      jdk
      maven
      visualvm
      (callPackage ../../pkgs/shell/jdk11-shell {})
    ];
  };
}
