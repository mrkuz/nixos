self: super:
{
  gnome3 = super.gnome3.overrideScope' (selfx: superx: {
    gnome-terminal = superx.gnome-terminal.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./transparency.patch
      ];
    });
  });
}
