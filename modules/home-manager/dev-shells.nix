{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.devShells;
  createPackage = mkSpec: rec {
    spec = (mkSpec { inherit pkgs; }) // { inherit sources; };
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
    home.packages = (map createPackage cfg.shells);
  };
}
