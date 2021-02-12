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
    home.packages = [
      pkgs.gradle
      pkgs.jdk
      pkgs.maven
      pkgs.visualvm
    ];
  };
}
