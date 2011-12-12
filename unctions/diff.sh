
function diff () {
  command diff -x .git -wru "$@"
}

export -f diff

