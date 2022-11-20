{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.javaDevelopment;

  linkIdeaPlugin = plugin:
    {
      name = "./JetBrains/IdeaIC2022.2/${plugin}";
      value = {
        source = (pkgs.callPackage ../../pkgs/misc/idea/plugins/${plugin} { }) + "/share/JetBrains/plugins/${plugin}";
      };
    };
in
{
  options.modules.javaDevelopment = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    xdg.dataFile = listToAttrs (map linkIdeaPlugin [ "checkstyle-idea" "kotest" "mybatisx" ]);

    home.packages = with pkgs; [
      eclipse-mat
      gradle
      jetbrains.idea-community
      jdk
      maven
      visualvm
      (callPackage ../../pkgs/shell/graalvm-shell { })
    ];
  };
}
