{ config, lib, pkgs, sources, ... }:

{
  time.timeZone = "Europe/Vienna";
  i18n = {
    supportedLocales = [
      "de_AT.UTF-8/UTF-8"
    ];
  };
}
