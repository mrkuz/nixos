{ lib, pkgs, sources, ... }:

let
  python-custom = pkgs.python3.withPackages (ps: with ps; [
    black
    pip
    tkinter
  ]);
in
{
  imports = [
    ../../profiles/users/nixos.nix
  ];

  xdg.desktopEntries.idle3 = {
    name = "IDLE";
    exec = "${python-custom}/bin/idle3";
    terminal = false;
    type = "Application";
    categories = [ "Development" "Utility" ];
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
