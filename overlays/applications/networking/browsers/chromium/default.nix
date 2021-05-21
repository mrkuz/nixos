self: super:
{
  chromium = super.symlinkJoin {
    name = "chromium";
    paths = [ super.chromium ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/chromium --add-flags "--single-process"
    '';
  };
}
