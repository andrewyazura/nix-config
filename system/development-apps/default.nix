{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.development-apps;
in
{
  options.modules.development-apps = {
    enable = mkEnableOption "Enable development GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.ghostty.packages.x86_64-linux.default
      jetbrains.idea
    ];
  };
}
