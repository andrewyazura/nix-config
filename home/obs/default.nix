{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.obs;

  profileDir = "${config.xdg.configHome}/obs-studio/basic/profiles/Untitled";

  # AMD hardware encode on Linux goes through VAAPI, not AMF or NVENC.
  # The _tex encoder reads the GPU texture directly, with no copy to system RAM.
  recordEncoder = pkgs.writeText "obs-record-encoder.json" (
    builtins.toJSON {
      # Pinned to the RX 7900 XTX. The iGPU also advertises HEVC encode, and
      # renderD* numbering is not stable across boots. Texture encode needs the
      # encode device to match the render device.
      vaapi_device = "/dev/dri/by-path/pci-0000:03:00.0-render";

      # Constant quantiser. Bitrate modes waste bits on static frames and starve
      # motion; CQP holds quality steady and lets the file size vary.
      rate_control = "CQP";
      qp = 20;

      keyint_sec = 2;

      # VCN 4.0 reports l1=0 for VAProfileHEVCMain/VAEntrypointEncSlice, so it has
      # no backward reference list. B-frames are not available on this hardware.
      bf = 0;
    }
  );

  basicIni = pkgs.writeText "obs-basic.ini" ''
    [General]
    Name=Untitled

    [Output]
    Mode=Advanced
    FilenameFormatting=%CCYY-%MM-%DD %hh-%mm-%ss

    [AdvOut]
    RecType=Standard
    RecFilePath=${config.home.homeDirectory}/Videos
    RecFormat2=hybrid_mp4
    RecEncoder=hevc_ffmpeg_vaapi_tex
    RecAudioEncoder=libfdk_aac
    RecTracks=1
    RecUseRescale=false
    Track1Bitrate=320

    [Video]
    BaseCX=2560
    BaseCY=1440
    OutputCX=2560
    OutputCY=1440
    FPSType=0
    FPSCommon=60
    ScaleType=bicubic
    ColorFormat=NV12
    ColorSpace=709
    ColorRange=Partial

    [Audio]
    SampleRate=48000
    ChannelSetup=Stereo
  '';
in
{
  options.modules.obs = {
    enable = mkEnableOption "Enable OBS Studio recording configuration";
  };

  config = mkIf cfg.enable {
    programs.obs-studio.enable = true;

    home.packages = with pkgs; [
      libva-utils
    ];

    # OBS rewrites both files when it exits, so they cannot be store symlinks.
    # Copy them instead. A rebuild resets any change made in the OBS GUI.
    home.activation.obsProfile = hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p ${escapeShellArg profileDir} ${escapeShellArg "${config.home.homeDirectory}/Videos"}
      run install -m 644 ${basicIni} ${escapeShellArg "${profileDir}/basic.ini"}
      run install -m 644 ${recordEncoder} ${escapeShellArg "${profileDir}/recordEncoder.json"}
    '';
  };
}
