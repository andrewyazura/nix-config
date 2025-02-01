{ pkgs, ... }: {
  programs.neovim = let
    toLua = str: ''
      lua << EOF
      ${str}
      EOF
    '';
    toLuaFile = path: ''
      lua << EOF
      ${builtins.readFile path}
      EOF
    '';
  in {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      wl-clipboard
      # required by:
      nodejs_22 # treesitter
      tree-sitter # treesitter
      ripgrep # telescope
      fd # telescope
      black # conform
      isort # conform
      nixfmt # conform
      stylua # conform
      lua-language-server # lsp
      pyright # lsp
      ruff # lsp
      nil # lsp
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = catppuccin-nvim;
        config = toLuaFile ./configs/options.lua;
        # this hack sets leader key before any other hotkeys are added
      }

      diffview-nvim
      nvim-web-devicons
      mini-icons
      plenary-nvim
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./configs/lsp.lua;
      }

      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./configs/gitsigns.lua;
      }

      {
        plugin = nvim-cmp;
        config = toLuaFile ./configs/cmp.lua;
      }
      cmp-cmdline
      cmp-path
      cmp-nvim-lsp
      cmp-buffer

      {
        plugin = telescope-nvim;
        config = toLuaFile ./configs/telescope.lua;
      }

      {
        plugin = nvim-treesitter.withPlugins
          (p: [ p.nix p.go p.python p.lua p.vimdoc ]);
        config = toLuaFile ./configs/treesitter.lua;
      }
      nvim-treesitter-context
      nvim-treesitter-refactor
      nvim-treesitter-textobjects

      {
        plugin = which-key-nvim;
        config = toLuaFile ./configs/which-key.lua;
      }

      {
        plugin = oil-nvim;
        config = toLua
          "require('oil').setup({ view_options = { show_hidden = true } })";
      }

      {
        plugin = conform-nvim;
        config = toLuaFile ./configs/conform.lua;
      }
    ];
  };
}
