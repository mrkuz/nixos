{ config, lib, pkgs, sources, vars, ... }:

{
  modules = {
    nonNixos.enable = true;
  };

  home.stateVersion = vars.stateVersion;
}
