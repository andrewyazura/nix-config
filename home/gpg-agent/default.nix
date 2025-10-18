{ lib, config, ... }:
with lib;
let cfg = config.modules.gpg-agent;
in {
  options.modules.gpg-agent = {
    enable = mkEnableOption "Enable GPG agent configuration";
  };
  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;

      defaultCacheTtl = 36000;
      maxCacheTtl = 36000;
      defaultCacheTtlSsh = 36000;
      maxCacheTtlSsh = 36000;
    };
  };
}
