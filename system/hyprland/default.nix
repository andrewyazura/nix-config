{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkgs = inputs.hyprland.packages.${system};

  tuigreetConfig = (pkgs.formats.toml { }).generate "tuigreet.toml" {
    session.command = "start-hyprland";
    remember.username = true;
    display = {
      show_time = true;
      time_format = "%a %d %b %H:%M";
      show_title = true;
      custom_title = "YoRHa UNIT ${toUpper (removePrefix "yorha" config.networking.hostName)}";
    };
    secret = {
      mode = "characters";
      characters = "*";
    };
    layout = {
      width = 40;
      window_padding = 0;
      container_padding = 2;
      prompt_padding = 1;
      widgets.status_bar = {
        show_command = true;
        show_session = false;
        show_power = true;
        show_background = false;
        show_caps_lock = true;
      };
    };
    power = {
      shutdown = "systemctl poweroff";
      reboot = "systemctl reboot";
    };
    theme = {
      text = "gray";
      time = "gray";
      container = "black";
      border = "gray";
      title = "white";
      greet = "gray";
      prompt = "darkgray";
      input = "white";
      action = "darkgray";
      button = "gray";
    };
  };
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "gtk" ];
    };

    services = {
      playerctld.enable = true;

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --config ${tuigreetConfig}";
          };
        };
      };
    };

    systemd.services.greetd = {
      serviceConfig.Type = "idle";
      unitConfig.After = mkForce [ "multi-user.target" ];
    };

    console = {
      colors = map (removePrefix "#") (import ../../common/ansi.nix);
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
      earlySetup = true;
    };

    security.pam.services.hyprlock = { };
  };
}
