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
    vaultPath = mkOption {
      type = types.str;
      default = "~/obsidian";
      description = "Path to Obsidian vault";
    };
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
          # tools
          fd
          ripgrep
          tree-sitter

          # formatters
          ktfmt
          nixfmt
          nodePackages.prettier
          ruff
          stylua

          # lsp servers
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

          {
            plugin = conform-nvim;
            config = toLuaFile ./configs/conform.lua;
          }

          diffview-nvim
          nvim-web-devicons # for diffview-nvim

          {
            plugin = flash-nvim;
            config = toLuaFile ./configs/flash.lua;
          }

          {
            plugin = fzf-lua;
            config = toLuaFile ./configs/fzf.lua;
          }

          {
            plugin = gitsigns-nvim;
            config = toLuaFile ./configs/gitsigns.lua;
          }

          hardtime-nvim

          markdown-preview-nvim

          mini-icons

          {
            plugin = neotest;
            config = toLuaFile ./configs/neotest.lua;
          }
          neotest-python # for neotest

          {
            plugin = nvim-autopairs;
            config = toLuaFile ./configs/autopairs.lua;
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
            plugin = nvim-dap;
            config = toLuaFile ./configs/dap.lua;
          }
          nvim-dap-ui # for nvim-dap
          nvim-dap-virtual-text # for nvim-dap
          nvim-nio # for nvim-dap-ui

          {
            plugin = nvim-surround;
            config = toLuaFile ./configs/surround.lua;
          }

          {
            plugin = obsidian-nvim;
            config = toLua ''
              ${builtins.readFile ./configs/obsidian.lua}
              setup_obsidian("${cfg.vaultPath}")
            '';
          }
          plenary-nvim # for obsidian-nvim

          {
            plugin = nvim-treesitter.withPlugins (p: [
              p.bash
              p.css
              p.dockerfile
              p.git_rebase
              p.gitcommit
              p.go
              p.html
              p.javascript
              p.json
              p.kotlin
              p.lua
              p.markdown
              p.nix
              p.python
              p.regex
              p.rust
              p.sql
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
            plugin = oil-nvim;
            config = toLuaFile ./configs/oil.lua;
          }

          {
            plugin = persistence-nvim;
            config = toLuaFile ./configs/persistence.lua;
          }

          {
            plugin = todo-comments-nvim;
            config = toLuaFile ./configs/todo-comments.lua;
          }

          {
            plugin = trouble-nvim;
            config = toLuaFile ./configs/trouble.lua;
          }

          {
            plugin = undotree;
            config = toLuaFile ./configs/undotree.lua;
          }

          {
            plugin = which-key-nvim;
            config = toLuaFile ./configs/which-key.lua;
          }
        ];
      };
  };
}
