{ lib, config, ... }:
with lib;
let cfg = config.modules.vesktop;
in {
  options.modules.vesktop = {
    enable = mkEnableOption "Enable vesktop configuration";
  };

  config = mkIf cfg.enable {
    home.file.".local/share/applications/vesktop.desktop".source =
      ./vesktop.desktop;
  };
}
