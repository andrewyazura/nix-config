{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
  };

  environment.systemPackages = with pkgs; [ vim git ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  documentation.nixos.enable = false;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];
  };

  users.users = {
    root.hashedPassword = "!";
    andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = import ../../ssh-keys.nix;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "24.11";
}
