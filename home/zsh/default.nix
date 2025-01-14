{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };

    shellAliases = {
      ll = "ls -l";
      gw = "git worktree";
      gpl = "git pull";
      gps = "git push";
      gc = "git commit";
      gst = "git status";
    };
  };
}
