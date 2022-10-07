{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
      modules = [
        "java.base"
        "java.desktop"
        "java.instrument"
        "java.logging"
        "java.management"
        "java.naming"
        "java.security.jgss"
      ];
      jre-custom = pkgs.stdenv.mkDerivation {
        pname = "jre-custom";
        version = "11";
        buildInputs = with pkgs; [ adoptopenjdk-bin autoPatchelfHook ];
        dontUnpack = true;
        dontInstall = true;
        stripDebugFlags = [ "--strip-unneeded" ];

        buildPhase = ''
          runHook preBuild
          jlink --module-path ${pkgs.jdk}/jmods \
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
          paths = with pkgs; [ busybox jre-custom ];
          pathsToLink = [ "/bin" ];
          # extraOutputsToInstall = [ "bin" ];
        };
        runAsRoot = ''
          install -m 777 -d /tmp
        '';
        config = {
          Cmd = [ "${pkgs.busybox}/bin/sh" ];
          # Entrypoint = [ "${jre-custom}/bin/java" "-jar" ];
        };
      };
    };
}
