{ config, lib, pkgs, sources, nixpkgs, modules, vars, profilesPath, ... }:

with lib;
let
  cfg = config.modules.dockerContainer;

  dockerConfig = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
    system = vars.currentSystem;
    specialArgs.profilesPath = profilesPath;
    modules = modules ++ [
      "${nixpkgs}/nixos/modules/virtualisation/docker-image.nix"
      {
        boot = {
          isContainer = true;
          specialFileSystems = lib.mkForce { };
        };

        services.journald.console = "/dev/console";
        systemd.services.systemd-logind.enable = false;
        systemd.services.console-getty.enable = false;

        environment.noXlibs = mkOverride 900 false;
        users.allowNoPasswordLogin = true;
      }
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
