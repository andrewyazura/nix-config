{ lib }:
with lib;
let
  sensitivePaths = [
    ".env"
    ".env.*"
    "**/.env"
    "**/.env.*"
    "~/.ssh/**"
    "~/.aws/**"
    "~/.config/sops/**"
    "**/secrets/**"
    "**/*credentials*"
    "**/*secret*"
    "**/*.pem"
    "**/*.key"
    "**/token*"
    "**/*.sqlite"
    "**/*.db"
    "**/.git/config"
  ];

  readOnlyUtils = [
    "cat"
    "head"
    "tail"
    "less"
    "more"
    "bat"
    "grep"
    "rg"
    "ag"
    "ack"
    "zgrep"
    "find"
    "fd"
    "locate"
    "whereis"
    "which"
    "command"
    "type"
    "ls"
    "tree"
    "exa"
    "eza"
    "stat"
    "file"
    "jq"
    "yq"
    "awk"
    "sed"
    "wc"
    "sort"
    "uniq"
    "cut"
    "tr"
    "tee"
    "xargs"
    "curl"
    "du"
    "df"
    "free"
    "top"
    "htop"
    "ps"
    "echo"
    "printf"
    "date"
    "pwd"
    "whoami"
    "python3"
    "python"
    "gpg"
  ];

  readOnlyDev = [
    "git status"
    "git diff:*"
    "git log:*"
    "git show:*"
    "git branch:*"
    "uv --version"
    "uv pip list"
    "uv pip freeze"
    "pip list"
    "pip show:*"
    "npm list:*"
    "yarn list:*"
  ];

  readOnlyGh = [
    "gh api:*"
    "gh pr view:*"
    "gh pr list:*"
    "gh search prs:*"
    "gh search issues:*"
    "gh search commits:*"
    "gh auth:*"
  ];

  readOnlyNix = [
    "nix eval:*"
    "nix build:*"
    "nix flake show:*"
    "nix flake metadata:*"
    "nix flake check:*"
    "nix fmt:*"
    "nix derivation show:*"
    "nix show-derivation:*"
    "nix-instantiate:*"
    "nix-store --query:*"
    "nix-store -q:*"
    "darwin-rebuild build:*"
  ];

  readOnlyPlatform = [
    "brew info:*"
    "launchctl list:*"
  ];

  stateModifiers = [
    "pip install:*"
    "pip uninstall:*"
    "uv:*"
    "npm:*"
    "yarn:*"
    "pnpm:*"
    "git add:*"
    "git commit:*"
    "git push:*"
    "git stash:*"
    "nix:*"
    "nix-env:*"
    "nix-shell:*"
    "make:*"
    "cargo:*"
    "go:*"
  ];

  denyPaths =
    paths:
    concatMap (path: [
      "Read(${path})"
      "Edit(${path})"
      "Write(${path})"
    ]) paths;

  bashCmds = cmds: map (cmd: "Bash(${cmd})") cmds;
  bashCmdsWithArgs = cmds: map (cmd: "Bash(${cmd}:*)") cmds;
  mcpTools = tools: map (tool: "mcp__${tool}") tools;
in
{
  allow = [
    "Glob"
    "Grep"
    "Read"
    "Skill"
    "Task"
    "WebFetch"
    "WebSearch"
    "Edit"
    "Write"
    "NotebookEdit"
  ]
  ++ bashCmdsWithArgs readOnlyUtils
  ++ bashCmds readOnlyDev
  ++ bashCmds readOnlyGh
  ++ bashCmds readOnlyNix
  ++ bashCmds readOnlyPlatform
  ++ mcpTools [
    "context7__*"
    "memory__*"
    "sequential-thinking__*"
    "mongodb__connect"
    "mongodb__list-databases"
    "mongodb__list-collections"
    "mongodb__find"
    "mongodb__count"
    "mongodb__aggregate"
    "mongodb__collection-schema"
    "mongodb__collection-indexes"
    "mongodb__collection-storage-size"
    "mongodb__db-stats"
    "mongodb__explain"
    "mongodb__atlas-list-projects"
    "mongodb__atlas-list-clusters"
    "mongodb__atlas-inspect-cluster"
    "mongodb__atlas-inspect-access-list"
    "mongodb__atlas-list-db-users"
    "ide__getDiagnostics"
    "datadog-mcp__*"
  ];

  deny = denyPaths sensitivePaths;

  ask = bashCmds stateModifiers;

  defaultMode = "default";
}
