{ pkgs, ... }:
let askpass = pkgs.kdePackages.ksshaskpass;
in {
  services = {
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${askpass}/bin/ksshaskpass";
  };

  environment = {
    systemPackages = [ askpass ];
    sessionVariables = { SSH_ASKPASS_REQUIRE = "prefer"; };
  };
}
