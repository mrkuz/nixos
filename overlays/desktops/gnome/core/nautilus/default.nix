self: super:
{
  gnome = super.gnome.overrideScope' (selfx: superx: {
    nautilus = superx.nautilus.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./icon-size.patch
      ];
    });
  });
}
