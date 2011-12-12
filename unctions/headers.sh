
function headers () {
  curl -i -k -L --head --silent "$@"
}

export -f headers

