self: super:
{
  gnome = super.gnome.overrideScope' (selfx: superx: {
    gnome-shell = superx.gnome-shell.overrideAttrs (old: {
      preFixup = ''
        gappsWrapperArgs+=(
          --prefix XDG_DATA_DIRS : "${super.shared-mime-info}/share"
          --add-flags "--no-x11"
        )
      '';
    });
  });
}
