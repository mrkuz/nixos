{ pkgs, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
{
  modules = {
    nonNixos.enable = true;
  };

  home.stateVersion = vars.stateVersion;
}
