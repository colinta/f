
function gush() {
  branch=`__git_ps1 "%s"`
  if [[ -z "$1" ]]; then
    remote=`git config branch.$branch.remote`
    if [[ -z "$remote" ]]; then
      remote=origin
    fi
  else
    remote="$1"
  fi
  echo git push "$remote" "$branch"
  git push "$remote" "$branch"
  beep
}

export -f gush