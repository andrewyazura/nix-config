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
