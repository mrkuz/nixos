self: super:
{
  gnome = super.gnome.overrideScope' (selfx: superx: {
    gnome-terminal = superx.gnome-terminal.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./transparency.patch
      ];
    });
  });
}
