{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.vscodeProfiles;
  createExtAttrs = name: extension: {
    name = ".vscode/${name}/extensions/${extension.vscodeExtUniqueId}";
    value = {
      source = "${extension}/share/vscode/extensions/${extension.vscodeExtUniqueId}";
      recursive = true;
    };
  };
  createProfileAttrs = configSource: profile:
    [
      {
        name = ".vscode/${profile.name}/User/settings.json";
        value = { source = "${configSource}/settings.json"; };
      }
      {
        name = ".vscode/${profile.name}/User/keybindings.json";
        value = { source = "${configSource}/keybindings.json"; };
      }
    ] ++ map (createExtAttrs profile.name) profile.extensions;
in {
  options.modules.vscodeProfiles = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    profiles = mkOption {
      type = types.listOf types.attrs;
    };
    configSource = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    home.file = listToAttrs (concatLists (map (createProfileAttrs cfg.configSource) cfg.profiles));
  };
}
