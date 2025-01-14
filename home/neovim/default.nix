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
      ripgrep
      wl-clipboard
      black
      isort
      nixfmt
      stylua
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = catppuccin-nvim;
        config = toLuaFile ./configs/options.lua;
        # this hack sets leader key before any other hotkeys are added
      }

      diffview-nvim
      plenary-nvim
      nvim-lspconfig

      {
        plugin = gitsigns-nvim;
        config = toLua "require('gitsigns').setup()";
      }

      {
        plugin = nvim-cmp;
        config = toLuaFile ./configs/cmp.lua;
      }
      cmp-cmdline
      cmp-path

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

      {
        plugin = which-key-nvim;
        config = toLuaFile ./configs/which-key.lua;
      }

      {
        plugin = oil-nvim;
        config = toLua "require('oil').setup()";
      }

      {
        plugin = conform-nvim;
        config = toLuaFile ./configs/conform.lua;
      }
    ];
  };
}
