{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.chromium;
in {
  options.modules.chromium = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
        { id = "chklaanhfefbnpoihckbnefhakgolnmc"; } # JSONView
        { id = "jnihajbhpnppcggbcgedagnkighmdlei"; } # LiveReload
        { id = "nlbjncdgjeocebhnmkbbbdekmmmcbfjd"; } # RSS Subscription extension
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      ];
    };
  };
}
