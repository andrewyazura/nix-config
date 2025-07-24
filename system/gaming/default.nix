{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    enable = mkEnableOption "Enable gaming configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mangohud prismlauncher ];

    programs = {
      gamescope.enable = true;
      steam.enable = true;
    };
  };
}
