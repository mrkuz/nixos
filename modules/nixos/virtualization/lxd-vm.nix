{ config, lib, pkgs, sources, nixpkgs, modules, vars, profilesPath, ... }:

with lib;
let
  cfg = config.modules.lxdVm;
  mkImage = import "${nixpkgs}/nixos/lib/make-disk-image.nix";
  evalConfig = import "${nixpkgs}/nixos/lib/eval-config.nix";

  diskImage = mkImage rec {
    inherit config lib pkgs;
    label = "nixos";
    format = "qcow2";
    partitionTableType = "efi";
    additionalSpace = "0M";
    copyChannel = false;
  };

  lxdConfig = (evalConfig {
    system = vars.currentSystem;
    modules = [ "${nixpkgs}/nixos/modules/virtualisation/lxc-container.nix" ];
  }).config;

  importScript = pkgs.writeShellScriptBin "import-image" ''
    ${pkgs.lxd}/bin/lxc image delete nixos || true
    ${pkgs.lxd}/bin/lxc image import --alias nixos \
      ${lxdConfig.system.build.metadata}/tarball/nixos-system-x86_64-linux.tar.xz \
      ${diskImage}/nixos.qcow2
  '';
in
{
  options.modules.lxdVm = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    boot = {
      growPartition = true;
      initrd = {
        availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
        kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
      };
      kernelParams = [ "console=ttyS0" ];
      loader = {
        grub = {
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
        timeout = 0;
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
        autoResize = true;
      };
      "/run/lxd-agent" = {
        device = "config";
        fsType = "9p";
      };
    };

    services.udev.extraRules = ''
      ACTION == "add", SYMLINK=="virtio-ports/org.linuxcontainers.lxd", TAG+="systemd", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl start lxd-agent.service"
    '';

    systemd.services.lxd-agent = {
      description = "LXD - agent";
      documentation = [ "https://linuxcontainers.org/lxd" ];
      serviceConfig = {
        Type = "notify";
        WorkingDirectory = "/run/lxd-agent";
        ExecStart = "/run/lxd-agent/lxd-agent";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      unitConfig = {
        ConditionPathExists = "/dev/virtio-ports/org.linuxcontainers.lxd";
        Before = [ "cloud-init.target" "cloud-init.service" "cloud-init-local.service" ];
        DefaultDependencies = "no";
        StartLimitInterval = "60";
        StartLimitBurst = "10";
      };
      requires = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    system.build.lxdImport = importScript;
  };
}
