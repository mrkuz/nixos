self: super:
{
  gnome = super.gnome.overrideScope' (selfx: superx: {
    mutter = superx.mutter.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./90e3d978.patch
      ];
    });
  });
}
