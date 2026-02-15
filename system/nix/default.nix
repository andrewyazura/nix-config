{
  ...
}:
{
  imports = [ ../../common/nix ];

  nix.settings.auto-optimise-store = true;
  nix.gc.dates = "weekly";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.pcscd.enable = true;

  programs = {
    gnupg.agent = {
      enable = true;
      settings = {
        default-cache-ttl = 86400;
        max-cache-ttl = 86400;
      };
    };

    ssh = {
      startAgent = true;
      enableAskPassword = true; # installs ssh-askpass, which obsidian depends on
    };
  };
}
