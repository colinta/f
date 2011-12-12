
function where () {
  find * -name "$1" "${@:2}"
}

export -f where

