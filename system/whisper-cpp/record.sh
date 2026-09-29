dir=$XDG_RUNTIME_DIR/dictate; pidf=$dir/rec.pid; wav=$dir/in.wav; logf=$dir/whisper.log
mkdir -p "$dir"
if [ -f "$pidf" ]; then
  pid=$(cat "$pidf"); rm "$pidf"
  kill -INT "$pid"; tail --pid="$pid" -f /dev/null
  notify-send whisper "Processing"
  whisper-cli -m "$WHISPER_CPP_MODEL" -f "$wav" -nt -np -l en 2>"$logf" | tr '\n' ' ' | sed 's/^ *//; s/ *$//' | wl-copy
  notify-send whisper "Copied"
else
  rec -q -c 1 -r 16000 -b 16 "$wav" & echo $! > "$pidf"
  notify-send whisper "Listening"
fi
