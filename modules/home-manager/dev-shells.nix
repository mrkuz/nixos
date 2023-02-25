{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.devShells;
  createPackage = mkSpec: rec {
    spec = (mkSpec { inherit pkgs; });
    package =
      if spec.fhs
      then
        pkgs.buildFhsShell spec
      else
        pkgs.buildShell spec;
  }.package;
in
{
  options.modules.devShells = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    shells = mkOption {
      type = types.listOf types.anything;
    };
  };

  config = mkIf cfg.enable {
    programs.vscode.enable = true;
    home.packages = (map createPackage cfg.shells);
  };
}
