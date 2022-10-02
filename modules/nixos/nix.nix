{ config, lib, pkgs, nixpkgs, self, vars, configName, ... }:

with lib;
let
  cfg = config.modules.nix;
in
{
  options.modules.nix = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes
        narinfo-cache-positive-ttl = 86400
        auto-optimise-store = true
        repeat = 0
      '';

      settings = {
        sandbox = true;
        substituters = [
          # "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
        ];
        trusted-public-keys = [
          # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        ];
      };

      registry.nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = {
          path = "${nixpkgs}";
          type = "path";
        };
      };
    };

    environment.etc."nixos/configuration.nix".text = ''
      nix = {
        nixPath = [ "nixpkgs=/nix/channels/nixos" ];
      };

      system.stateVersion = "${vars.stateVersion}";
    '';
    environment.etc."nixos/options.json".source = "${config.system.build.manual.optionsJSON}/share/doc/nixos/options.json";
    environment.etc."nixos/system-packages".text =
      let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sorted = builtins.sort (a: b: lib.toLower a < lib.toLower b) (lib.unique packages);
        formatted = builtins.concatStringsSep "\n" sorted;
      in
      formatted;

    environment.extraInit = ''
      export NIX_PATH="nixpkgs=/nix/channels/nixos"
    '';

    systemd.tmpfiles.rules = [
      "d   /nix/channels        0755 root root  -  -"
      "L+  /nix/channels/nixos     -    -    -  -  ${nixpkgs}"
      "L+  /nix/current            -    -    -  -  ${self}"
    ];

    environment.systemPackages = with pkgs; [
      niv
      nixpkgs-fmt
      rnix-lsp
      (callPackage ../../pkgs/tools/nix/nixos-option { inherit configName; })
    ];
  };
}
