{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.vscodeProfiles;
  createExtAttrs = name: extension: {
    name = "${name}-${extension.name}";
    value = hm.dag.entryAfter [ "installPackages" ]
      ''
        ln -sfv ${extension} /tmp/extension.vsix
        ${pkgs.vscode}/bin/code \
          --user-data-dir "$HOME/.vscode/${name}" \
          --extensions-dir "$HOME/.vscode/${name}/extensions" \
          --install-extension /tmp/extension.vsix \
          --force
        rm /tmp/extension.vsix
      '';
  };
  createProfileAttrs = profile:
    [
      {
        name = "${profile.name}";
        value = hm.dag.entryAfter [ "installPackages" ]
          ''
            [ -d "$HOME/.vscode/${profile.name}/User/" ] || mkdir -p "$HOME/.vscode/${profile.name}/User/"
            [ -e "$HOME/.vscode/${profile.name}/User/settings.json" ] || install -m 665 "$HOME/.config/Code/User/settings.json" "$HOME/.vscode/${profile.name}/User/"
            [ -e "$HOME/.vscode/${profile.name}/User/keybindings.json" ] || install -m 665 "$HOME/.config/Code/User/keybindings.json" "$HOME/.vscode/${profile.name}/User/"

            [ -d "$HOME/.vscode/${profile.name}/extensions/" ] || mkdir -p "$HOME/.vscode/${profile.name}/extensions/"
            for i in $HOME/.vscode/extensions/*; do
              extension=$(basename $i)
              [ -e "$HOME/.vscode/${profile.name}/extensions/$extension" ] || ln -svf $i $HOME/.vscode/${profile.name}/extensions/$extension
            done
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
    extensionPackages = mkOption {
      default = [];
      type = types.listOf types.package;
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = cfg.extensionPackages;
    };
    home.activation = listToAttrs (concatLists (map createProfileAttrs cfg.profiles));
  };
}
