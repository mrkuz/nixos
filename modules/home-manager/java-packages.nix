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
      gradle
      jdk
      maven
      visualvm
      (callPackage ../../pkgs/shell/jdk11-shell {})
      (callPackage ../../pkgs/shell/graalvm-shell {})
    ];
  };
}
