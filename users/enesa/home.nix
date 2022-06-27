{ pkgs, ... }:

let
  python-custom = (pkgs.python3.withPackages(ps: [ ps.tkinter ]));
in {
  imports = [
    ../_all/home.nix
  ];

  home.packages = with pkgs; [
    firefox
    jetbrains.pycharm-community
    python-custom
    python310Packages.bpython
  ];

  xdg.desktopEntries.idle3 = {
    name = "IDLE";
    exec = "${python-custom}/bin/idle3";
    terminal = false;
    type = "Application";
    categories = [ "Development" "Utility"];
  };
}
