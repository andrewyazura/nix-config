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
      ( ${pkgs.mpv}/bin/mpv --no-video --really-quiet "${soundsDir}/${file}" >/dev/null 2>&1 & )
      cat >/dev/null
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
      invocationNum=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.invocationNum // 1')
      if [ "$invocationNum" -le 1 ]; then
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
