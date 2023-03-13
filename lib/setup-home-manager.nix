{ self, nixpkgs, inputs }:

{ name, user, system }: inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = self.utils.mkPkgs system;
  modules = [
    {
      _module.args.nixpkgs = nixpkgs;
      _module.args.inputs = inputs;
      _module.args.vars = self.vars;
      _module.args.sources = self.sources;
    }
    {
      home = {
        homeDirectory = "/home/${user}";
        username = user;
      };
    }
    (../users + "/${name}" + /home.nix)
  ] ++ self.utils.attrsToValues self.homeManagerModules;
}
