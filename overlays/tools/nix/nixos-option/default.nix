self: super:
{
  nixos-option = super.symlinkJoin {
    name = "nixos-option";
    paths = [ super.nixos-option ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nixos-option --add-flags "-I nixpkgs=/etc/nixos/compat"
    '';
  };
}
