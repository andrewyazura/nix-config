{ lib, pkgs }:
let
  soundsDir = ../claude/sounds;
  configDir = "$HOME/.gemini/antigravity-cli";

  playSoundScript =
    {
      file,
      outputJson ? "{}",
    }:
    pkgs.writeShellScript "agy-play-${lib.removeSuffix ".ogg" file}" ''
      input=$(cat)
      convId=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.conversationId // "default"')
      rm -f "''${XDG_RUNTIME_DIR:-/tmp}/agy-turn-$convId"
      ( ${pkgs.mpv}/bin/mpv --no-video --really-quiet "${soundsDir}/${file}" >/dev/null 2>&1 & )
      echo '${outputJson}'
    '';

  playRandomSoundScript =
    {
      files,
      outputJson ? "{}",
    }:
    let
      count = toString (builtins.length files);
      paths = lib.concatMapStringsSep " " (f: "\"${soundsDir}/${f}\"") files;
    in
    pkgs.writeShellScript "agy-play-random" ''
      input=$(cat)
      convId=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.conversationId // "default"')
      turnId=$(echo "$input" | ${pkgs.jq}/bin/jq -r '[(.lastUserInput // "" | @base64), (.initialNumSteps // "" | tostring)] | join(":")')
      marker="''${XDG_RUNTIME_DIR:-/tmp}/agy-turn-$convId"
      savedTurn=""
      if [ -f "$marker" ]; then
        savedTurn=$(cat "$marker" 2>/dev/null)
      fi
      if [ "$savedTurn" != "$turnId" ]; then
        echo "$turnId" > "$marker"
        set -- ${paths}
        shift $((RANDOM % ${count}))
        ( ${pkgs.mpv}/bin/mpv --no-video --really-quiet "$1" >/dev/null 2>&1 & )
      fi
      echo '${outputJson}'
    '';

  playSubmit = playRandomSoundScript {
    files = [
      "officer1.ogg"
      "officer2.ogg"
    ];
    outputJson = builtins.toJSON { injectSteps = [ ]; };
  };

  playStop = playSoundScript {
    file = "upgbar.ogg";
    outputJson = builtins.toJSON { };
  };

  postToolUseLog = pkgs.writeShellScript "agy-post-tool-log" ''
    input=$(cat)
    command=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.toolCall.args.CommandLine // ""')
    cwd=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.toolCall.args.Cwd // ""')
    project=$(${pkgs.coreutils}/bin/basename "$cwd")
    timestamp=$(${pkgs.coreutils}/bin/date -u +"%Y-%m-%dT%H:%M:%SZ")
    if [ -n "$command" ]; then
      echo "[$timestamp] [$project] [run_command] $command" >> "${configDir}/bash-commands.log"
    fi
    echo '{}'
  '';
in
{
  sound-effects = {
    enabled = true;
    PreInvocation = [
      {
        type = "command";
        command = "${playSubmit}";
        timeout = 5;
      }
    ];
    Stop = [
      {
        type = "command";
        command = "${playStop}";
        timeout = 5;
      }
    ];
    PostToolUse = [
      {
        matcher = "run_command";
        hooks = [
          {
            type = "command";
            command = "${postToolUseLog}";
            timeout = 5;
          }
        ];
      }
    ];
  };
}
