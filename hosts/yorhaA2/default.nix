{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  username = "andrew";
  hostname = "yorhaA2";
  capsLockAndEscapeSwap = lib.filter (
    m:
    lib.elem m.HIDKeyboardModifierMappingSrc [
      30064771129
      30064771113
    ]
  ) config.system.keyboard.userKeyMapping;
in
{
  imports = [
    ../../darwin
    inputs.private-config.darwinModules.default
  ];

  modules = {
    profiles = {
      desktop.enable = true;
      development.enable = true;
      gaming.enable = true;
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs hostname;
    };
    sharedModules = [
      inputs.private-config.homeManagerModules.default
      inputs.sops-nix.homeManagerModules.sops
    ];

    users.${username} = {
      imports = [
        ../../home
        ../../users/andrew/home
        ../../users/andrew/home/yorhaA2
      ];

      home.homeDirectory = lib.mkForce "/Users/${username}";
    };
  };

  sops = {
    age.sshKeyPaths = [ "/Users/andrew/.ssh/id_ed25519_yorhaA2_nixconfig_3011" ];
    secrets.netrc = {
      sopsFile = ../../secrets/netrc-yorhaA2;
      format = "binary";
    };
  };

  networking.hostName = hostname;
  networking.computerName = hostname;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  services.openssh.enable = true;

  environment = {
    systemPackages = with pkgs; [
      gnupg
    ];
  };

  system = {
    stateVersion = 6;
    primaryUser = username;
    defaults.smb.NetBIOSName = hostname;

    keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = false;
      swapCapsLockAndEscape = true;
      swapLeftCtrlAndFn = true;
    };

    activationScripts.keyboard.text = lib.mkForce ''
      echo "configuring keyboard..." >&2
      hidutil property --set '{"UserKeyMapping":${builtins.toJSON capsLockAndEscapeSwap}}' > /dev/null
      hidutil property --matching '{"Built-In":true,"PrimaryUsagePage":1,"PrimaryUsage":6}' --set '{"UserKeyMapping":${builtins.toJSON config.system.keyboard.userKeyMapping}}' > /dev/null
    '';
  };

  time.timeZone = "Europe/Warsaw";
}
