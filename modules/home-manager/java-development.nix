{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.javaDevelopment;
in {
  options.modules.javaDevelopment = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eclipse-mat
      gradle
      jetbrains.idea-community
      jdk
      maven
      visualvm
      (callPackage ../../pkgs/shell/graalvm-shell {})
    ];
  };
}
