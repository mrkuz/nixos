let
  sources = import ../../../nix/sources.nix;
in [
  sources."vscode:intellicode-api-usage-examples" # dependency for vscodeintellicode
  sources."vscode:markdown-preview-github-styles"
  sources."vscode:vscode-emacs-friendly"
  sources."vscode:vscode-theme-darcula"
  sources."vscode:vscode-icons"
  sources."vscode:vscode-status-bar-format-toggle"
  sources."vscode:vscodeintellicode"
  # sources."vscode:remote-ssh"
]
