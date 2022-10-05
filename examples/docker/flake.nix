{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
      modules = [ "java.base" ];
      jre-custom = pkgs.stdenv.mkDerivation {
        pname = "jre-custom";
        version = "17";
        buildInputs = [ pkgs.jdk17_headless ];
        dontUnpack = true;
        dontInstall = true;
        stripDebugFlags = [ "--strip-unneeded" ];

        buildPhase = ''
          runHook preBuild
          jlink --module-path ${pkgs.jdk}/lib/openjdk/jmods \
            --add-modules ${pkgs.lib.concatStringsSep "," modules} \
            --strip-debug \
            --no-man-pages \
            --no-header-files \
            --compress=2 \
            --verbose \
            --output $out
          runHook postBuild
        '';
      };
    in
    {
      defaultPackage."${system}" = pkgs.dockerTools.buildImage {
        name = "hello-docker";
        tag = "latest";
        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          paths = with pkgs; [ bash coreutils findutils which jre-custom ];
          pathsToLink = [ "/bin" ];
        };
        config = {
          Cmd = [ "${pkgs.bash}/bin/bash" ];
        };
      };
    };
}
