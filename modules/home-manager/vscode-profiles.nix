{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.vscodeProfiles;
  createActivation = mkProfile: rec {
    profile = mkProfile { inherit sources; };
    activation = {
      name = "${profile.name}";
      value = hm.dag.entryAfter [ "writeBoundary" ]
        ''
          [ -d "$HOME/.vscode/${profile.name}/User/" ] || mkdir -p "$HOME/.vscode/${profile.name}/User/"
          [ -e "$HOME/.vscode/${profile.name}/User/settings.json" ] || install -m 665 "$HOME/.config/Code/User/settings.json" "$HOME/.vscode/${profile.name}/User/"
          [ -e "$HOME/.vscode/${profile.name}/User/keybindings.json" ] || install -m 665 "$HOME/.config/Code/User/keybindings.json" "$HOME/.vscode/${profile.name}/User/"
        '';
    };
  }.activation;
  createPackage = mkProfile: rec {
    profile = mkProfile { inherit sources; };
    package = pkgs.buildVscode {
      inherit sources;
      name = "${ profile. alias}";
      userDataDir = ".vscode/${ profile. name}";
      extensions = profile.extensions;
    };
  }.package;
in
{
  options.modules.vscodeProfiles = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    profiles = mkOption {
      type = types.listOf types.anything;
    };
  };

  config = mkIf cfg.enable {
    programs.vscode.enable = true;
    home.packages = (map createPackage cfg.profiles);
    home.activation = listToAttrs (map createActivation cfg.profiles);
  };
}
