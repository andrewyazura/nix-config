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
}
