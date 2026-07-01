{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/andrew/system
    ../../users/andrew/system/yorha2b

    inputs.private-config.nixosModules.default
  ];

  modules = {
    profiles = {
      desktop.enable = true;
      development.enable = true;
      gaming.enable = true;
    };

    gnome.enable = false;
    hyprland.enable = true;
    logitech-g920.enable = true;
    ollama.enable = true;
    tailscale.enable = true;
    wooting.enable = true;
    wivrn.enable = true;
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
      ../../users/andrew/home/yorha2b

      inputs.private-config.homeManagerModules.default
    ];

    modules = {
      gnome.enable = false;
      guitar.enable = true;
      waybar.enable = true;

      hyprland = {
        enable = true;
        output = [
          {
            output = "DP-1";
            mode = "3840x2160@144";
            position = "0x0";
          }
          {
            output = "DP-2";
            mode = "2560x1440@144";
            position = "3840x360";
          }
        ];
      };

      sway = {
        enable = false;
        output =
          let
            wallpaperPath = ../../common/wallpapers/nix-black-4k.png;
          in
          {
            DP-1 = {
              position = "0 0";
              mode = "3840x2160@144Hz";
              bg = "${wallpaperPath} fill";
            };

            DP-2 = {
              position = "3840 360";
              mode = "2560x1440@144Hz";
              bg = "${wallpaperPath} fill";
            };
          };

        focus-output = "DP-2";
      };
    };
  };

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha2b_nixconfig_1510" ];
    secrets.netrc = {
      sopsFile = ../../secrets/netrc-yorha2b;
      format = "binary";
    };
  };

  boot = {
    kernelPatches = [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];

    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      extraPools = [
        "disk_alpha"
      ];
    };

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        configurationLimit = 10;
        gfxmodeEfi = "2560x1440";
      };

      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostId = "a0489983";

  powerManagement.cpuFreqGovernor = "performance";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam.package = pkgs.steam.override {
    extraBwrapArgs = [ "--bind /disk_alpha /disk_alpha" ];
  };

  environment.systemPackages = with pkgs; [
    blender
  ];

  environment.sessionVariables = {
    STEAM_COMPAT_MOUNTS = "/disk_alpha";
  };

  time.timeZone = "Europe/Warsaw";

  system.stateVersion = "24.11";
}
