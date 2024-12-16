{ pkgs, ... }: {
  # To setup the wheel, execute
  # `sudo usb_modeswitch -v 046d -p c261 -c system/oversteer/modeswitch`

  environment = {
    systemPackages = with pkgs; [
      oversteer
      usb-modeswitch
    ];

    # etc."usb_modeswitch.d/046d:c261".source = ./modeswitch;
  };

  # this doesn't work, fails with error
  # > usb_modeswitch is called in udev rules but not installed by udev

  # adding usb-modeswitch or usb-modeswitch-data to udev packages doesn't help
  # similar issue: https://github.com/NixOS/nixpkgs/issues/11647

  # services.udev = {
  #   packages = with pkgs; [
  #     usb-modeswitch-data
  #   ];
  #
  #   extraRules = ''
  #     ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="usb_modeswitch '%b/%k'"
  #   '';
  # };
}
