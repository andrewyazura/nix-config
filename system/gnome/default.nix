{ pkgs, ... }: {
  environment.systemPackages = with pkgs.gnomeExtensions; [
    pop-shell
  ];
}
