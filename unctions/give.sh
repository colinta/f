
function give() {
  branch=`__git_ps1 "%s"`
  if [[ -z "$1" ]]; then
    remote=`git config branch.$branch.remote`
    if [[ -z "$remote" ]]; then
      remote=origin
    fi
  else
    remote="$1"
  fi
  echo "git checkout live ; git pull live ; merge $branch ; push live ; checkout $branch"
  git checkout live && git pull "$remote" live && git merge "$branch" && git push "$remote" live && git checkout "$branch"
  beep
}

export -f give