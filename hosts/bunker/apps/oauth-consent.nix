{
  config,
  pkgs,
  ...
}:
let
  # Homepage, privacy policy and terms of service for the Google Calendar OAuth
  # app. Google requires all three over HTTPS before the app can leave
  # "Testing" publishing status.
  oauthConsentPages = pkgs.runCommand "oauth-consent-pages" { } ''
    mkdir -p $out
    cp ${./oauth-pages/index.html} $out/index.html
    cp ${./oauth-pages/privacy.html} $out/privacy.html
    cp ${./oauth-pages/terms.html} $out/terms.html
  '';

  # Same three pages for the Google Drive OAuth client that rclone uses for
  # Minecraft world backups.
  mcBackupsConsentPages = pkgs.runCommand "mc-backups-oauth-consent-pages" { } ''
    mkdir -p $out
    cp ${./oauth-pages-mc-backups/index.html} $out/index.html
    cp ${./oauth-pages-mc-backups/privacy.html} $out/privacy.html
    cp ${./oauth-pages-mc-backups/terms.html} $out/terms.html
  '';
in
{
  services.nginx.virtualHosts."vault.andrewyazura.com" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."andrewyazura.crt".path;
    sslCertificateKey = config.sops.secrets."andrewyazura.key".path;

    root = oauthConsentPages;

    locations."/" = {
      index = "index.html";
    };
  };

  services.nginx.virtualHosts."mc-backups.andrewyazura.com" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."andrewyazura.crt".path;
    sslCertificateKey = config.sops.secrets."andrewyazura.key".path;

    root = mcBackupsConsentPages;

    locations."/" = {
      index = "index.html";
    };
  };
}
