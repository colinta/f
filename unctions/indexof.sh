
function indexof () {
  local haystack
  local needle
  local i
  
  if [[ $# -gt 2 ]]; then
    haystack=("$@")
    needle="${haystack[$# - 1]}"
    local dashes="${haystack[$# - 2]}"
    if [[ "--" != "$dashes" ]]; then
      echo "When indexing an array, you must seperate the needle with --"
      echo
      echo "e.g. indexof \"$@\" -- -r"
      return 1
    fi
  
    for ((i=0; i < $# - 2; i++)); do
      if [[ "${haystack[$i]}" = "$needle" ]]; then
        echo -n $i
      fi
    done
  else
    haystack="$1"
    needle="$2"
  
    for ((i=0; i < ${#haystack} - ${#needle} + 1; i++)); do
      if [[ ${haystack:$i:${#needle}} = "$needle" ]]; then
        echo -n $i
        return 0
      fi
    done
  fi
  return 1
}

export -f indexof

