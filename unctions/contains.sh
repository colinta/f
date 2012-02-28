
function contains () {
  [[ -n "$2" && ${1/%*$2*/$2} = "$2" ]] && echo $2;
  return $?
}

export -f contains

