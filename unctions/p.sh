
function p () {
  pushd ~ > /dev/null
  source .profile
  popd > /dev/null
}

export -f p

