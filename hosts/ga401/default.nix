{ config, pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ../../modules/system.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [ vaapiVdpau ];
  };

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;

    package = config.boot.kernelPackages.nvidiaPackages.production;
    nvidiaSettings = true;
    open = false;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd =
          lib.mkIf config.hardware.nvidia.prime.offload.enable true;
      };

      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  system.stateVersion = "23.11";
}