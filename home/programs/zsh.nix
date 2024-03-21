{ lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "zsh-autosuggestions" "zsh-syntax-highlighting" ];
    };
  };
}
