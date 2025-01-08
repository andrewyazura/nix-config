{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.ghostty.packages.x86_64-linux.default
    obsidian
    spotify
    telegram-desktop
    vesktop # fixed screensharing

    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })

    tree
    neofetch
    nixfmt
  ];
}
