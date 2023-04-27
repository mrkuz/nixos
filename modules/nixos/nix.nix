{ config, lib, pkgs, sources, nixpkgs, self, vars, systemName, ... }:

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
    minimal = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nix = {
        package = pkgs.nix;
        extraOptions = ''
          experimental-features = nix-command flakes
          narinfo-cache-positive-ttl = 86400
          keep-outputs = true
          keep-derivations = true
          auto-optimise-store = true
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
      };

      systemd.services.nix-daemon.enable = true;
      systemd.sockets.nix-daemon.enable = true;
    }
    (mkIf (!cfg.minimal) {
      # Use local nixpkgs

      nix.registry.nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = lib.mkForce {
          path = "${nixpkgs}";
          type = "path";
        };
      };

      systemd.tmpfiles.rules = [
        "d   /root/.nix-defexpr        0755  root  root  -  -"
        "L+  /root/.nix-defexpr/nixos     -     -        -  -  ${nixpkgs}"
        "L+  /root/.nix-defexpr/nixpkgs   -     -        -  -  ${nixpkgs}"
      ];

      # Provide compatibility layer for non-flake utils
      environment.etc."nixos/compat/default.nix".text = ''
        { ... }:

        let
          nixpkgs = import ${nixpkgs} {};
        in
        nixpkgs
      '';

      environment.etc."nixos/compat/nixos/default.nix".text = ''
        { ... }:

        let
          current = import ${self};
        in
        current.nixosConfigurations."${systemName}"
      '';

      environment.etc."nixos/configuration.nix".text = ''
        nix = {
          nixPath = [ "nixpkgs=${nixpkgs}" ];
        };

        system.name = "${systemName}";
        system.stateVersion = "${vars.stateVersion}";
        system.configurationRevision = "${vars.rev}";
      '';

      environment.etc."nixos/current".source = self;
      environment.etc."nixos/nixpkgs".source = nixpkgs;
      environment.etc."nixos/options.json".source =
        if config.documentation.nixos.enable
        then "${config.system.build.manual.optionsJSON}/share/doc/nixos/options.json"
        else
          pkgs.writeTextFile {
            name = "options.json";
            text = "{}";
          };

      environment.etc."nixos/system-packages".text =
        let
          packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
          sorted = builtins.sort (a: b: lib.toLower a < lib.toLower b) (lib.unique packages);
          formatted = builtins.concatStringsSep "\n" sorted;
        in
        formatted;

      environment.extraInit = ''
        export NIX_PATH="nixpkgs=${nixpkgs}"
      '';

      environment.systemPackages = with pkgs; [
        nixos-option
      ];
    })
  ]);
}
