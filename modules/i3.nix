{ pkgs, ... }: {
  environment.pathsToLink = [ "/libexec" ];

  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    enable = true;

    desktopManager = { xterm.enable = false; };
    displayManager = { defaultSession = "none+i3"; };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ rofi polybar i3lock-color feh dunst acpi ];
      extraSessionCommands = ''
        eval $(gnome-keyring-daemon --start)
        export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
      '';
    };

    xkb = {
      layout = "us,ua,de";
      variant = "";
      options = "grp:alt_shift_toggle";
    };
  };
}
