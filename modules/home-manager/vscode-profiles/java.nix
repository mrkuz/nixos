{ sources }:

let
  baseExtensions = import ./base-extensions.nix { inherit sources; };
in
{
  name = "Java";
  alias = "jcode";
  extensions = baseExtensions ++ [
    sources."vscode:java" # dependency for vscode-spring-boot-dashboard, vscode-java-pack
    sources."vscode:sonarlint-vscode"
    sources."vscode:vscode-java-debug" # dependency for vscode-spring-boot-dashboard, vscode-java-pack
    sources."vscode:vscode-java-dependency" # dependency for vscode-java-pack
    sources."vscode:vscode-java-pack"
    sources."vscode:vscode-java-test" # dependency for vscode-java-pack
    sources."vscode:vscode-lombok"
    sources."vscode:vscode-maven" # dependency for vscode-java-pack
    sources."vscode:vscode-spring-boot" # dependency for vscode-spring-boot-dashboard, vscode-boot-dev-pack
    sources."vscode:vscode-spring-boot-dashboard" # dependency for vscode-boot-dev-pack
    sources."vscode:vscode-spring-initializr" # dependency for vscode-boot-dev-pack
    sources."vscode:vscode-xml"
    # sources."vscode-boot-dev-pack"
  ];
}
