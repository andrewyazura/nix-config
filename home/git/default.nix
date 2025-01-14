{
  programs.git = {
    enable = true;
    aliases = {
      ps = "push";
      pl = "pull";
      a = "add";
      c = "commit -m";
      l = "log";
      s = "status";
    };
  };
}
