self: super:
{
  chromium = super.symlinkJoin {
    name = "chromium";
    paths = [ super.chromium ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/chromium --add-flags "--start-maximized --ozone-platform-hint=auto --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization"
    '';
  };
}
