{ config, lib, pkgs, sources, nixpkgs, modules, vars, ... }:

with lib;
let
  cfg = config.modules.dockerContainer;

  dockerConfig = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
    system = vars.currentSystem;
    modules = modules ++ [
      {
        boot = {
          isContainer = true;
          specialFileSystems = lib.mkForce { };
        };

        systemd.services.console-getty.enable = false;
        services.journald.console = "/dev/console";
        users.allowNoPasswordLogin = true;
      }
      "${nixpkgs}/nixos/modules/virtualisation/docker-image.nix"
    ];
  }).config;
in
{
  options.modules.dockerContainer = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    system.build.dockerTar = dockerConfig.system.build.tarball;
  };
}
