{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.wivrn;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  options.modules.wivrn = {
    enable = mkEnableOption "Enable WiVRn";
  };

  config = mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      openFirewall = true;
      package = inputs.nixpkgs-26-05.legacyPackages.${system}.wivrn;
    };

    services.avahi.enable = true;
  };
}
