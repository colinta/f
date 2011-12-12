
function g() {
  if [[ $# -eq 0 ]]; then
    git status
  else
    git "$@"
  fi
}

export -f g