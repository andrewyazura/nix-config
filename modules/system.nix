{ pkgs, ... }: {
  boot.loader.systemd-boot.configurationLimit = 10;

  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.neovim.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    nixfmt
    pulseaudio
  ];
  environment.variables.EDITOR = "nvim";

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      xkb = {
        layout = "us,ua";
        variant = "";
        options = "grp:win_space_toggle";
      };
    };
  };

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # pulseaudio server uses this to acquire realtime priority
  # https://nixos.org/manual/nixos/stable/options#opt-security.rtkit.enable
  security.rtkit.enable = true;

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
