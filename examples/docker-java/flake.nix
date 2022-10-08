{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = (import nixpkgs {
        inherit system;
        # config.allowBroken = true;
      });
      pkgsMusl = pkgs.pkgsMusl;
      sourcePerArch = {
        packageType = "jdk";
        vmType = "hotspot";
        x86_64 = {
          version = "17.0.4";
          build = "1";
          # JDK
          # url = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_linux_hotspot_17.0.4.1_1.tar.gz";
          # sha256 = "5fbf8b62c44f10be2efab97c5f5dbf15b74fae31e451ec10abbc74e54a04ff44";
          # JDK (alpine)
          url = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_alpine-linux_hotspot_17.0.4.1_1.tar.gz";
          sha256 = "1a1706304c26da0d8d2e05127c5aa7dba00e5401b2c0228c8ae894d2812beee0";
        };
      };

      jdkPackage = import "${nixpkgs}/pkgs/development/compilers/adoptopenjdk-bin/jdk-linux-base.nix" { inherit sourcePerArch; };
      jdk = pkgsMusl.callPackage jdkPackage {};
      modules = [
        "java.base"
        "java.desktop"
        "java.instrument"
        "java.logging"
        "java.management"
        "java.naming"
        "java.security.jgss"
      ];
      jre = pkgsMusl.stdenv.mkDerivation {
        pname = "jre-custom";
        version = "17";
        buildInputs = [ jdk pkgs.autoPatchelfHook ];
        dontUnpack = true;
        dontInstall = true;
        stripDebugFlags = [ "--strip-unneeded" ];

        buildPhase = ''
          runHook preBuild
          jlink --module-path ${jdk}/jmods \
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
      packages.x86_64-linux.jdk = jdk;
      packages.x86_64-linux.jre = jre;
      defaultPackage."${system}" = pkgs.dockerTools.buildImage {
        name = "mrkuz/java";
        tag = "latest";
        copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ pkgsMusl.busybox jre ];
            pathsToLink = [ "/bin" ];
            # extraOutputsToInstall = [ "bin" ];
        };
        runAsRoot = ''
          install -m 777 -d /tmp
        '';
        config = {
          Cmd = [ "/bin/sh" ];
          # Entrypoint = [ "/bin/java" "-jar" ];
        };
      };
    };
}
