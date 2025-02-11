{
  services.xserver = {
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };
}
