function todo
  if test (count $argv) -eq 0
    echo "Usage: todo TITLE"
  else
    emacsclient -n -c -F '((name . "org-protocol-capture"))' "org-protocol://capture://b/$argv"
  end
end
