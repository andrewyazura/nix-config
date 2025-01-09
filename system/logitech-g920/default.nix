{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [ usb-modeswitch ];
    etc."usb_modeswitch.d/046d:c261".source = ./modeswitch;
  };

  # alternatively, use this command
  # `sudo usb_modeswitch -v 046d -p c261 -c system/logitech-g920/modeswitch`
}
