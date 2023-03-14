{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.idea;

  linkPlugin = plugin:
    {
      name = "./JetBrains/${cfg.version}/${plugin.name}";
      value = {
        source = "${plugin}/share/JetBrains/plugins/${plugin.name}";
      };
    };
in
{
  options.modules.idea = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    package = mkOption {
      default = pkgs.jetbrains.idea-community;
      type = types.package;
    };
    version = mkOption {
      default = "IdeaIC2022.3";
      type = types.str;
    };
    plugins = mkOption {
      type = types.listOf types.package;
    };
  };

  config = mkIf cfg.enable {

    xdg.dataFile = listToAttrs (map linkPlugin cfg.plugins);

    home.packages = [ cfg.package ];
  };
}
