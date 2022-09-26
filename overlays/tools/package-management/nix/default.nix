self: super:
{
  nix = super.nix.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./vscode.patch
    ];
  });
}
