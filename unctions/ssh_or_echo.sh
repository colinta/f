
function ssh_or_echo () {
  if [[ -t 1 ]]; then
    ssh "$@"
  else
    echo $1
  fi
}

export -f ssh_or_echo

