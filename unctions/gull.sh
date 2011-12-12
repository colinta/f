
function gull() {
  branch=`__git_ps1 "%s"`
  if [[ -z "$1" ]]; then
    remote=`git config branch.$branch.remote`
    if [[ -z "$remote" ]]; then
      remote=origin
    fi
  else
    remote="$1"
  fi
  echo git pull "$remote" "$branch"
  git pull "$remote" "$branch"
}

export -f gull