{ lib, pkgs }:
let
  soundsDir = ./sounds;

  soundHook = command: {
    type = "command";
    inherit command;
    timeout = 10;
    async = true;
  };

  playSound = file: soundHook "${pkgs.mpv}/bin/mpv --no-video --really-quiet ${soundsDir}/${file}";

  playRandomSound =
    files:
    let
      count = toString (builtins.length files);
      paths = lib.concatMapStringsSep " " (f: "${soundsDir}/${f}") files;
    in
    soundHook "bash -c 'set -- ${paths}; shift $((RANDOM % ${count})); ${pkgs.mpv}/bin/mpv --no-video --really-quiet \"$1\"'";

  postToolUseLog = pkgs.writeShellScript "claude-post-tool-log" ''
    input=$(cat)
    command=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.tool_input.command // ""')
    project=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.cwd // ""' | ${pkgs.coreutils}/bin/basename)
    timestamp=$(${pkgs.coreutils}/bin/date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "[$timestamp] [$project] [Bash] $command" >> ~/.claude/bash-commands.log
  '';

  permissionRequestLog = pkgs.writeShellScript "claude-permission-request-log" ''
    input=$(cat)
    tool=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.tool_name // "unknown"')
    detail=$(echo "$input" | ${pkgs.jq}/bin/jq -r '
      if .tool_name == "Bash" then (.tool_input.command // "")
      elif .tool_name == "Write" or .tool_name == "Edit" or .tool_name == "Read" then (.tool_input.file_path // "")
      else (.tool_input | tostring | .[0:200])
      end
    ')
    project=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.cwd // ""' | ${pkgs.coreutils}/bin/basename)
    timestamp=$(${pkgs.coreutils}/bin/date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "[$timestamp] [$project] [$tool] $detail" >> ~/.claude/permission-requests.log
  '';
in
{
  UserPromptSubmit = [
    {
      hooks = [
        (playRandomSound [
          "officer1.ogg"
          "officer2.ogg"
        ])
      ];
    }
  ];
  PermissionRequest = [
    {
      hooks = [
        (playSound "alarm.ogg")
        {
          type = "command";
          command = "${permissionRequestLog}";
          timeout = 5;
          async = true;
        }
      ];
    }
  ];
  Stop = [
    {
      hooks = [ (playSound "upgbar.ogg") ];
    }
  ];
  Notification = [
    {
      matcher = "^(?!permission_prompt|idle_prompt)";
      hooks = [ (playSound "bldaca.ogg") ];
    }
  ];
  PostToolUse = [
    {
      matcher = "Bash";
      hooks = [
        {
          type = "command";
          command = "${postToolUseLog}";
          timeout = 5;
          async = true;
        }
      ];
    }
  ];
}
