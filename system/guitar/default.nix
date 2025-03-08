{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ guitarix qjackctl reaper ];
  services.pipewire.jack.enable = true;
}
