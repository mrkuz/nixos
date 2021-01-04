{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.vscodeProfiles;
  createActivation = profile:
    {
      name = "${profile.name}";
      value = hm.dag.entryAfter [ "writeBoundary" ]
        ''
          [ -d "$HOME/.vscode/${profile.name}/User/" ] || mkdir -p "$HOME/.vscode/${profile.name}/User/"
          [ -e "$HOME/.vscode/${profile.name}/User/settings.json" ] || install -m 665 "$HOME/.config/Code/User/settings.json" "$HOME/.vscode/${profile.name}/User/"
          [ -e "$HOME/.vscode/${profile.name}/User/keybindings.json" ] || install -m 665 "$HOME/.config/Code/User/keybindings.json" "$HOME/.vscode/${profile.name}/User/"
        '';
      };
  createPackage = profile:
    (pkgs.callPackage ../../pkgs/vscode/vscode-plus.nix {
      name = "${profile.alias}";
      userDataDir = ".vscode/${profile.name}";
      extensions = profile.extensions;
    });
in {
  options.modules.vscodeProfiles = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    profiles = mkOption {
      type = types.listOf types.attrs;
    };
  };

  config = mkIf cfg.enable {
    programs.vscode.enable = true;
    home.activation = listToAttrs (map createActivation cfg.profiles);
    home.packages = (map createPackage cfg.profiles);
  };
}
