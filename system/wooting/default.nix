{ pkgs, ... }: { services.udev.packages = [ pkgs.wooting-udev-rules ]; }
