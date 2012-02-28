
function slice () {
  local i=$1
  local stop=$2
  local count=$(($# - 2))
  local length

  if [[ "$i" = ':' ]]; then
    i=0
  elif [[ "$i" -lt 0 ]]; then
    i=$(($count + $i))
  fi

  if [[ "$stop" = ':' ]]; then
    stop=$count
  elif [[ "$stop" -lt 0 ]]; then
    stop=$(($count + $stop))
  fi

  if [[ $i -lt 0 ]]; then
    i=0
  elif [[ $i -gt $count ]]; then
    i=$((count - 1))
  fi

  if [[ $stop -lt 0 ]]; then
    stop=0
  elif [[ $stop -gt $count ]]; then
    stop=$((count - 1))
  fi

  length=$(($stop - $i))
  if [[ $length -le 0 ]]; then
    __slice=( )
  else
    i=$(($i + 3))
    __slice=("${@:$i:$length}")
  fi
}

export -f slice

