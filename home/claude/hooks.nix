{ lib, pkgs }:
let
  soundsDir = ./sounds;
  mpvBin = lib.getExe pkgs.mpv;

  soundHook = command: {
    type = "command";
    inherit command;
    timeout = 10;
    async = true;
  };

  playSound = file: soundHook "${mpvBin} --no-video --really-quiet ${soundsDir}/${file}";
in
{
  UserPromptSubmit = [
    {
      hooks = [
        (soundHook "bash -c '${mpvBin} --no-video --really-quiet ${soundsDir}/officer$((RANDOM % 2 + 1)).ogg'")
      ];
    }
  ];
  PostToolUseFailure = [
    {
      matcher = "Bash";
      hooks = [ (playSound "alarm.ogg") ];
    }
  ];
  PermissionRequest = [
    {
      hooks = [ (playSound "alarm.ogg") ];
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
}
