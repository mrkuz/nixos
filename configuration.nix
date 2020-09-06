{ config, lib, pkgs, ... }:

let
  home-manager = import <home-manager> {};

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

  nixos-packages = pkgs.writeShellScriptBin "nixos-packages" ''
    nix-instantiate --strict --json --eval -E 'builtins.map (p: p.name) (import <nixpkgs/nixos> {}).config.environment.systemPackages' | nix run nixpkgs.jq -c jq -r '.[]' | sort -u
  '';

  command-not-found = pkgs.writeShellScriptBin "command-not-found" ''
    echo "$1: command not found"
  '';

in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot loader
  boot.tmpOnTmpfs = true;
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = false;
    };
    grub = {
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = false;
    };
    generationsDir.enable = false;
    timeout = 3;
  };

  # Networking
  networking = {
    hostName = "nixos";
    interfaces.wlp2s0.useDHCP = true;
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.resolved.enable = true;
  environment.etc.openvpn.source = "${pkgs.update-systemd-resolved}/libexec/openvpn";

  # Localization
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Vienna";

  # SMART
  services.smartd.enable = true;

  # Filesystem
  swapDevices = [ { device = "/dev/vg00/swap"; } ];
  fileSystems."/home" = {
    device = "/dev/vg00/home";
    fsType = "ext4";
  };
  fileSystems."/data" = {
    device = "/dev/vg00/data";
    fsType = "ext4";
  };
  fileSystems."/data/overlay/home/mnt" = {
    fsType = "overlay";
    device = "overlay";
    options = [
      "lowerdir=/home"
      "upperdir=/data/overlay/home/rw"
      "workdir=/data/overlay/home/work"
    ];
  };

  # Graphics
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  hardware.nvidia = {
    nvidiaPersistenced = true;
    modesetting.enable = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  # Scanning
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  # Miscellanous hardware
  hardware.steam-hardware.enable = true;

  # Security
  # security.pam.enableEcryptfs = true;

  # Virtualization
  virtualisation = {
    # anbox.enable = true;
    docker.enable = true;
    docker.enableNvidia = true;
    libvirtd.enable = true;
    podman.enable = true;
    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
    virtualbox.host.headless = true;
  };

  # Gnome
  services.xserver = {
    desktopManager.gnome3.enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.nvidiaWayland = true;
  };
  services.gnome3 = {
    core-utilities.enable = false;
    chrome-gnome-shell.enable = true;
    gnome-keyring.enable = true;
  };
  security.pam.services.gdm.enableGnomeKeyring = true;
  programs = {
    evince.enable = true;
    file-roller.enable = true;
    gnome-terminal.enable = true;
    seahorse.enable = true;
  };

  # Flatpak
  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # fish
  programs.fish.enable = true;

  # Android
  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  # Packages
  nix.nixPath = [ "nixpkgs=/nix/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" ];
  nixpkgs.config.allowUnfree = true;
  programs.chromium.enable = true;
  programs.command-not-found.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.nixos.enable = true;
  nixpkgs.config.kodi.enableInputStreamAdaptive = true;
  environment.systemPackages = with pkgs; [
    # Tools
    dos2unix
    git
    htop
    mkpasswd
    nmap
    p7zip
    python38Packages.ansible
    python38Packages.ansible-lint
    python38Packages.wakeonlan
    pwgen
    rclone
    ripgrep
    rsync
    tmux
    unrar
    unzip
    vim
    zip
    # Gnome core utilities
    baobab
    gnome3.eog
    gnome3.gedit
    gnome3.gnome-calculator
    gnome3.gnome-calendar
    gnome3.gnome-characters
    gnome3.gnome-clocks
    gnome3.gnome-font-viewer
    gnome3.gnome-screenshot
    gnome3.gnome-software
    gnome3.gnome-system-monitor
    gnome3.gnome-weather
    gnome3.nautilus
    simple-scan
    # Gnome utilities
    gnome3.gnome-tweaks
    gnome3.libgnome-keyring
    # Gnome extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    # Default applications
    google-chrome
    thunderbird
    # Applications
    gimp
    gparted
    remmina
    vlc
    # Ubuntu look & feel
    yaru-theme
    # Docker
    docker-compose
    fuse-overlayfs
    # Virtualizaton
    vagrant
    # X utilities
    glxinfo
    vdpauinfo
    vulkan-tools
    weston
    xclip
    xorg.xkill
    xpra
    xwayland
    # Base packages
    binutils
    bridge-utils
    cifs-utils
    dnsmasq
    ecryptfs
    efibootmgr
    exfat
    file
    libva-utils
    lm_sensors
    ntfs3g
    openvpn
    parted
    pciutils
    psmisc
    python38Packages.cgroup-utils
    python38Packages.pip
    smartmontools
    strace
    tuptime
    update-systemd-resolved
    zlib
    # Build essentials
    cmake
    gcc
    gnumake
    # NixOS
    home-manager.home-manager
    # Scripts
    command-not-found
    nixos-packages
    nvidia-offload
    # Kodi
    kodi
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    dejavu_fonts
    fira-code
    fira-code-symbols
    google-fonts
    noto-fonts
    source-code-pro
    ubuntu_font_family
  ];

  # Users
  users = {
    mutableUsers = false;
    groups.markus.gid = 1000;
    groups.enesa.gid = 1001;
    users = {
      markus = {
        uid = 1000;
        description = "Markus";
        isNormalUser = true;
        group = "markus";
        extraGroups = [ "wheel" "adbusers" "docker" "libvirtd"  "lp" "scanner" "vboxusers" ];
        hashedPassword = "$6$mFkTicworPz1frRb$L4ZpTQKCtWdsmndgunILqG9u6cy2qaF9PmxP3DGulpxnLbpDZpm98s/sxLHLDoDbogP8NwRdJM/IMdBckug0N/";
        shell = pkgs.fish;
      };

      enesa = {
        uid = 1001;
        description = "Enesa";
        isNormalUser = true;
        group = "enesa";
        extraGroups = [ "lp" "scanner" ];
        hashedPassword = "$6$7b8/r8wdK5n2gx$E0WZG8YvOQZfsyOtw3D23EqfhHvq/onstbDEcgXIAmsc1BcgV9dlteXkcrCqiXwB29AwkMkGMQ6LxaUZ2/Qfc/";
        shell = pkgs.bash;
      };

      root = {
        hashedPassword = "*";
        packages = [ pkgs.emacs ];
      };
    };
  };

  system.stateVersion = "20.03";
}
