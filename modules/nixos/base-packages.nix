{ config, lib, pkgs, sources, ... }:

with lib;
let
  cfg = config.modules.basePackages;
in
{
  options.modules.basePackages = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      age
      bat
      bind
      binutils
      bridge-utils
      btrfs-progs
      cifs-utils
      curl
      dmidecode
      dnsmasq
      dos2unix
      duf
      efibootmgr
      exfat
      fd
      file
      fzf
      git
      groff
      htop
      inetutils
      iftop
      iproute2
      jq
      lm_sensors
      lsof
      lzip
      mkpasswd
      most
      ncdu
      ncurses
      nfs-utils
      nmap
      ntfs3g
      openssl
      openvpn
      p7zip
      parted
      pciutils
      powertop
      psmisc
      pwgen
      python310Packages.cgroup-utils
      # python310Packages.wakeonlan
      rclone
      ripgrep
      rng-tools
      rsync
      smartmontools
      socat
      strace
      # tldr
      tmux
      trashy
      tree
      tunctl
      unrar
      unzip
      usbutils
      vim
      wget
      xfsprogs
      zip
      zlib
    ];
  };
}
