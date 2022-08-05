{ pkgs, ... }:

let
  python-custom = (pkgs.python3.withPackages(ps: [ ps.black ps.pip ps.tkinter ]));
in {
  imports = [
    ../_all/home.nix
  ];

  xdg.desktopEntries.idle3 = {
    name = "IDLE";
    exec = "${python-custom}/bin/idle3";
    terminal = false;
    type = "Application";
    categories = [ "Development" "Utility"];
  };

  home.packages = with pkgs; [
    firefox
    gradle
    jdk
    maven
    python-custom
    python310Packages.bpython
    vscode
  ];
}
