{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    enable = mkEnableOption "Enable gaming configuration";
    enableMinecraft = mkEnableOption "Enable minecraft launcher";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mangohud ]
      ++ lib.optionals cfg.enableMinecraft [ pkgs.prismlauncher ];

    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam.enable = true;
    };
  };
}
