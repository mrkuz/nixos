{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.commandNotFound;

  command-not-found = pkgs.writeShellScriptBin "command-not-found" ''
    echo "$1: command not found"
  '';
in
{
  options.modules.commandNotFound = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.command-not-found.enable = false;
    environment.systemPackages = with pkgs; [
      command-not-found
    ];
  };
}
