{ pkgs, ... }: {
  programs.neovim =
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = path: "lua << EOF\n${builtins.readFile path}\nEOF\n";
  in {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
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
        plugin = nvim-treesitter.withPlugins (p: [
       	  p.nix
          p.go
          p.python
          p.lua
          p.vimdoc
        ]);
        config = toLuaFile ./configs/treesitter.lua;
      }
      nvim-treesitter-context
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./configs/options.lua}
    '';
  };
}
