
function title () {
  echo -ne "\033]0;$@\007"
}

export -f title

