self: super:
{
  makeModulesClosure = { kernel, firmware, rootModules, allowMissing ? false }:
    super.makeModulesClosure {
      inherit kernel firmware allowMissing;
      rootModules = [ ];
    };
}
