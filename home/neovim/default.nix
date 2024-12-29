{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      diffview-nvim
      gitsigns-nvim

      nvim-lspconfig

      nvim-cmp
      cmp-buffer
      cmp-cmdline
      cmp-path

      telescope-nvim
    ];
  };
}
