{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.vscodeProfiles;
  createExtAttrs = name: extension: {
    name = "${name}-${extension.name}";
    value = ''
      ln -sfv ${extension} /tmp/extension.vsix
      ${pkgs.vscode}/bin/code \
        --user-data-dir "$HOME/.vscode/${name}" \
        --extensions-dir "$HOME/.vscode/${name}/extensions" \
        --install-extension /tmp/extension.vsix \
        --force
      rm /tmp/extension.vsix
    '';
  };
  createProfileAttrs = configSource: profile:
    [
      {
        name = "${profile.name}";
        value = ''
          [ -d "$HOME/.vscode/${profile.name}/User/" ] || mkdir -p "$HOME/.vscode/${profile.name}/User/"
          install -m 665 ${configSource}/settings.json "$HOME/.vscode/${profile.name}/User/"
          install -m 665 ${configSource}/keybindings.json "$HOME/.vscode/${profile.name}/User/"
        '';
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
    home.activation = listToAttrs (concatLists (map (createProfileAttrs cfg.configSource) cfg.profiles));
  };
}
