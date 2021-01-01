function fish_prompt
  set _status $status
  set _user (id -un)
  if test $_status -eq 0
    set_color green
  else
    set_color red
  end

  echo -n  "$_user@"(hostname)" ><(((°> "
  set_color normal
  echo -n (pwd | sed 's|/home/markus|~|')

  set _head (git rev-parse HEAD 2>/dev/null)
  if string length $_head >/dev/null; and test $_head != "HEAD"
    echo -n " ["
    set_color yellow
    set _branch (git symbolic-ref --short HEAD 2>/dev/null)
    if string length $_branch >/dev/null
      echo -n $_branch
    else
      set _tag (git describe --exact-match --tags HEAD 2>/dev/null)
      if string length $_tag >/dev/null
        echo -n $_tag
      else
        echo -n "<dettached>"
      end
    end
    echo -n "@"(string sub -l 8 $_head)
      if ! git diff --quiet --exit-code
        echo -n "*"
      end
      if ! git diff --staged --quiet --exit-code
        echo -n "^"
      end
      if git rev-parse stash >/dev/null 2>&1
        echo -n "!"
      end
      set_color normal
      echo -n "]"
  end

 if test -f /.dockerenv
    echo -n " ["
    set_color brred
    echo -n "container"
    set_color normal
    echo -n "]"
  end

  if test -f /.nixenv
    echo -n " ["
    set_color brred
    echo -n "nix-shell"
    set_color normal
    echo -n "]"
  end

  echo
  if test $_user = "root"
    echo "# "
  else
    echo "\$ "
  end
end
