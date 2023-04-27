{ config, lib, pkgs, sources, vars, ... }:

{
  modules = {
    nonNixOs.enable = true;
  };

  home.stateVersion = vars.stateVersion;
}
