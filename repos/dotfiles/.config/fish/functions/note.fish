function note
  if test (count $argv) -eq 0
    echo "Usage: note TITLE"
  else
    emacsclient -n -c -F '((name . "org-protocol-capture"))' "org-protocol://capture://N/$argv"
  end
end
