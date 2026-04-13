{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.darwin-packages;
in
{
  options.modules.darwin-packages = {
    gnuTools.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GNU coreutils with g prefix";
    };
  };

  config = mkMerge [
    (mkIf cfg.gnuTools.enable {
      environment.systemPackages = with pkgs; [
        coreutils
      ];
    })
  ];
}
