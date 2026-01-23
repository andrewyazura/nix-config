{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.neovim;
in
{
  options.modules.neovim = {
    enable = mkEnableOption "Enable neovim configuration";
  };

  config = mkIf cfg.enable {
    programs.neovim =
      let
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
      in
      {
        enable = true;
        defaultEditor = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = with pkgs; [
          tree-sitter
          ripgrep
          fd

          ruff
          nixfmt
          stylua

          lua-language-server
          nil
          ty
          typescript-language-server
        ];

        plugins = with pkgs.vimPlugins; [
          {
            plugin = catppuccin-nvim;
            config = toLuaFile ./configs/options.lua;
            # this hack sets leader key before any other hotkeys are added
          }

          diffview-nvim
          nvim-web-devicons # for diffview-nvim

          {
            plugin = gitsigns-nvim;
            config = toLuaFile ./configs/gitsigns.lua;
          }

          {
            plugin = nvim-cmp;
            config = toLuaFile ./configs/cmp.lua;
          }
          cmp-buffer # for nvim-cmp
          cmp-cmdline # for nvim-cmp
          cmp-nvim-lsp # for nvim-cmp
          cmp-nvim-lsp-document-symbol # for nvim-cmp
          cmp-nvim-lsp-signature-help # for nvim-cmp
          cmp-path # for nvim-cmp

          {
            plugin = nvim-treesitter.withPlugins (p: [
              p.css
              p.go
              p.html
              p.javascript
              p.json
              p.kotlin
              p.lua
              p.nix
              p.python
              p.rust
              p.toml
              p.typescript
              p.vimdoc
              p.yaml
            ]);
            config = toLuaFile ./configs/treesitter.lua;
          }
          nvim-treesitter-context # for nvim-treesitter
          nvim-treesitter-textobjects # for nvim-treesitter

          {
            plugin = which-key-nvim;
            config = toLuaFile ./configs/which-key.lua;
          }

          {
            plugin = trouble-nvim;
            config = toLuaFile ./configs/trouble.lua;
          }

          {
            plugin = todo-comments-nvim;
            config = toLuaFile ./configs/todo-comments.lua;
          }

          {
            plugin = oil-nvim;
            config = toLua "require('oil').setup({ view_options = { show_hidden = true } })";
          }

          {
            plugin = conform-nvim;
            config = toLuaFile ./configs/conform.lua;
          }

          {
            plugin = fzf-lua;
            config = toLuaFile ./configs/fzf.lua;
          }

          hardtime-nvim
          flash-nvim
          mini-icons

          {
            plugin = nvim-dap;
            config = toLuaFile ./configs/dap.lua;
          }
          nvim-dap-virtual-text
          nvim-dap-ui
          nvim-nio # for nvim-dap-ui
        ];
      };
  };
}
