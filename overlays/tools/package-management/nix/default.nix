self: super:
{
  nixFlakes = super.nixFlakes.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./subpaths.patch
      ./vscode.patch
    ];
  });
}
