{ config, lib, pkgs, nixpkgs, ... }:

with lib;
let
  cfg = config.modules.chromeOs;
in
{
  options.modules.chromeOs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    home.file.".config/systemd/user/cros-garcon.service.d/override.conf" = {
      text = ''
        [Service]
        Environment="PATH=%h/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin"
        Environment="XDG_DATA_DIRS=%h/.nix-profile/share:%h/.local/share:/usr/local/share:/usr/share"
      '';
    };
  };
}
