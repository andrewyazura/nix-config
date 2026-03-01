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

  denyPaths =
    paths:
    concatMap (path: [
      "Read(${path})"
      "Edit(${path})"
      "Write(${path})"
    ]) paths;

  bashCmds = cmds: map (cmd: "Bash(${cmd})") cmds;
  mcpTools = tools: map (tool: "mcp__${tool}") tools;
in
{
  allow = [
    "Bash"
    "Edit"
    "Glob"
    "Grep"
    "NotebookEdit"
    "Read"
    "Skill"
    "Task"
    "WebFetch"
    "WebSearch"
    "Write"
  ]
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

  deny =
    (denyPaths sensitivePaths)
    ++ bashCmds [
      "sudo *"
      "git push --force *"
      "git push -f *"
      "git reset --hard *"
      "git clean -f *"
      "git clean -fd *"
      "git branch -D *"
      "chmod 777 *"
    ];
}
