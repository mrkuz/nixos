{ config, lib, pkgs, sources, nixpkgs, modules, vars, ... }:

with lib;
let
  cfg = config.modules.lxdContainer;

  lxdConfig = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
    system = vars.currentSystem;
    modules = modules ++ [
      "${nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
      {
        boot.isContainer = true;
        services.openssh.enable = false;
      }
    ];
  }).config;

  importScript = pkgs.writeShellScriptBin "import-image" ''
    ${pkgs.lxd}/bin/lxc image delete nixos || true
    ${pkgs.lxd}/bin/lxc image import --alias nixos \
      ${lxdConfig.system.build.metadata}/tarball/nixos-system-x86_64-linux.tar.xz \
      ${lxdConfig.system.build.tarball}/tarball/nixos-system-x86_64-linux.tar.xz
  '';
in
{
  options.modules.lxdContainer = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    system.build.lxdImport = importScript;
  };
}
