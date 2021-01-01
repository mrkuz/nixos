self: super:
{
  nixFlakes = super.nixFlakes.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
       ./nixFlakes.patch
    ];
  });
}
