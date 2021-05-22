self: super:
{
  chromium = super.symlinkJoin {
    name = "chromium";
    paths = [ super.chromium ];
    buildInputs = [ super.makeWrapper ];
    # wrapProgram $out/bin/chromium --add-flags "--single-process"
    postBuild = ''
      wrapProgram $out/bin/chromium --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy"
    '';
  };
}
