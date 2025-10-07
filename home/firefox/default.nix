{ lib, config, ... }:
with lib;
let cfg = config.modules.firefox;
in {
  options.modules.firefox = {
    enable = mkEnableOption "Enable firefox configuration";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.mainProfile = {
        id = 0;
        name = "main";
        # isDefault = true;
        extensions = [
          # "@contain-facebook"
          # "@testpilot-containers"
          "FirefoxColor@mozilla.com"
          "addon@darkreader.org"
          "adguardadblocker@adguard.com"
          "firefox-extension@steamdb.info"
          "firefox@ghostery.com"
          "uBlock0@raymondhill.net"
          "vpn@proton.ch"

          "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" # augmented steam
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden
          "{458160b9-32eb-4f4c-87d1-89ad3bdeb9dc}" # youtube anti-translate
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" # youtube dislike
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # stylus
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" # vimium
        ];
      };
    };
  };
}
