
function startat () {
  local i=$(($1 + 2))
  __startat=("${@:$i}")
}

export -f startat

