
function replace () {
  echo ${1/%$2/$3}
}

export -f replace

