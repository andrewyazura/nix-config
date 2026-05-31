{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.neovim;
  neotest-gradle = pkgs.vimUtils.buildVimPlugin {
    pname = "neotest-gradle";
    version = "unstable";
    src = inputs.neotest-gradle-src;
    dependencies = with pkgs.vimPlugins; [
      neotest
      nvim-nio
      plenary-nvim
    ];
  };
in
{
  options.modules.neovim = {
    enable = mkEnableOption "Enable neovim configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
      ripgrep
      tree-sitter
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withRuby = false;
      withPython3 = false;

      extraPackages = with pkgs; [
        # tools
        fd
        ripgrep
        tree-sitter

        # formatters
        ktfmt
        nixfmt
        prettier
        ruff
        stylua

        # lsp servers
        gopls
        lua-language-server
        nil
        ty
        typescript-language-server
        zls
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = catppuccin-nvim;
          type = "lua";
          config = builtins.readFile ./configs/options.lua;
          # this hack sets leader key before any other hotkeys are added
        }

        {
          plugin = conform-nvim;
          type = "lua";
          config = builtins.readFile ./configs/conform.lua;
        }

        diffview-nvim
        nvim-web-devicons # for diffview-nvim

        {
          plugin = flash-nvim;
          type = "lua";
          config = builtins.readFile ./configs/flash.lua;
        }

        {
          plugin = fzf-lua;
          type = "lua";
          config = builtins.readFile ./configs/fzf.lua;
        }

        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./configs/gitsigns.lua;
        }

        hardtime-nvim
        markdown-preview-nvim
        mini-icons

        {
          plugin = neotest;
          type = "lua";
          config = builtins.readFile ./configs/neotest.lua;
        }
        neotest-python # for neotest
        neotest-gradle # for neotest

        {
          plugin = nvim-autopairs;
          type = "lua";
          config = builtins.readFile ./configs/autopairs.lua;
        }

        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./configs/cmp.lua;
        }
        cmp-buffer # for nvim-cmp
        cmp-cmdline # for nvim-cmp
        cmp-nvim-lsp # for nvim-cmp
        cmp-nvim-lsp-document-symbol # for nvim-cmp
        cmp-nvim-lsp-signature-help # for nvim-cmp
        cmp-path # for nvim-cmp

        {
          plugin = nvim-dap;
          type = "lua";
          config = builtins.readFile ./configs/dap.lua;
        }
        nvim-dap-ui # for nvim-dap
        nvim-dap-virtual-text # for nvim-dap
        nvim-nio # for nvim-dap-ui

        {
          plugin = nvim-surround;
          type = "lua";
          config = builtins.readFile ./configs/surround.lua;
        }

        {
          plugin = nvim-treesitter.withPlugins (p: [
            p.bash
            p.css
            p.dockerfile
            p.git_rebase
            p.gitcommit
            p.go
            p.html
            p.java
            p.javascript
            p.json
            p.kotlin
            p.lua
            p.markdown
            p.markdown_inline
            p.nix
            p.python
            p.regex
            p.rust
            p.sql
            p.toml
            p.typescript
            p.vimdoc
            p.yaml
            p.zig
          ]);
          type = "lua";
          config = builtins.readFile ./configs/treesitter.lua;
        }
        nvim-treesitter-context # for nvim-treesitter
        nvim-treesitter-textobjects # for nvim-treesitter

        {
          plugin = oil-nvim;
          type = "lua";
          config = builtins.readFile ./configs/oil.lua;
        }

        {
          plugin = persistence-nvim;
          type = "lua";
          config = builtins.readFile ./configs/persistence.lua;
        }

        {
          plugin = todo-comments-nvim;
          type = "lua";
          config = builtins.readFile ./configs/todo-comments.lua;
        }

        {
          plugin = trouble-nvim;
          type = "lua";
          config = builtins.readFile ./configs/trouble.lua;
        }

        {
          plugin = undotree;
          type = "lua";
          config = builtins.readFile ./configs/undotree.lua;
        }

        {
          plugin = which-key-nvim;
          type = "lua";
          config = builtins.readFile ./configs/which-key.lua;
        }
      ];
    };
  };
}
