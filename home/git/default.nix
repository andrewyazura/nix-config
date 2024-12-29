{ ... }: {
  programs.git = {
    enable = true;
    aliases = { gw = "worktree"; };
  };
}
