{ config, lib, pkgs, inputs , ... }:

with lib;
let
  cfg = config.modules.basePackages;
  home-manager-package = (import inputs.home-manager { inherit pkgs; }).home-manager;
in {
  options.modules.basePackages = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    programs.fish.enable = true;
    services.haveged.enable = true;
    services.tuptime.enable = true;

    environment.systemPackages = with pkgs; [
      bind
      binutils
      bridge-utils
      cifs-utils
      curl
      # curlftpfs
      dmidecode
      dnsmasq
      dos2unix
      # ecryptfs
      efibootmgr
      exfat
      file
      git
      # home-manager-package
      # htop
      inetutils
      iproute
      lm_sensors
      lzip
      mkpasswd
      niv
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
      python38Packages.cgroup-utils
      # python38Packages.wakeonlan
      rclone
      ripgrep
      rsync
      smartmontools
      strace
      tmux
      unrar
      unzip
      vim
      zip
      zlib
    ];
  };
}
