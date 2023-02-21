let
  sources = import ../../../nix/sources.nix;
  baseExtensions = import ./base-extensions.nix;
in {
  name = "Web";
  alias = "wcode";
  extensions = baseExtensions ++ [
    sources."vscode:auto-close-tag" # dependency auto-complete-tag
    sources."vscode:auto-complete-tag" # dependency for vuejs-extension-pack
    sources."vscode:auto-rename-tag" # dependency auto-complete-tag
    sources."vscode:color-highlight"
    sources."vscode:javascriptsnippets" # dependency for vuejs-extension-pack
    sources."vscode:npm-intellisense" # dependency for vuejs-extension-pack
    sources."vscode:prettier-vscode" # dependency for vuejs-extension-pack
    sources."vscode:vetur" # dependency for vuejs-extension-pack
    sources."vscode:vite" # dependency for vuejs-extension-pack
    sources."vscode:vitest-explorer" # dependency for vuejs-extension-pack
    sources."vscode:volar" # dependency for vuejs-extension-pack
    sources."vscode:vscode-eslint" # dependency for vuejs-extension-pack
    sources."vscode:vscode-typescript-vue-plugin" # dependency for vuejs-extension-pack
    sources."vscode:vue-vscode-snippets" # dependency for vuejs-extension-pack
    sources."vscode:vuejs-extension-pack"
  ];
}
