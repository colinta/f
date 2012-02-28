
function _beep {
  if [[ -n `type -t beep` ]]; then
    beep
  fi
}

function g() {
  if [[ $# -eq 0 ]]; then
    git status
  else
    git "$@"
  fi
}

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
  _beep
}

function gull() {
  local branch=`__git_ps1 "%s"`
  local pull=`git config branch.live.merge | sed -E 's=refs/heads/(.*)=\1='`
  if [[ -z $pull ]]; then
    pull=$branch
  fi

  local args=""
  local remote=""
  if [[ -z "$1" || "${1:0:2}" == "--" ]]; then
    remote=`git config branch.$branch.remote`
    if [[ -z "$remote" ]]; then
      remote=origin
    fi

    args="$@"
  else
    remote="$1"
    args="${@:2}"
  fi
  echo git pull $args "$remote" "$pull"
  git pull $args "$remote" "$pull"
}

function gush() {
  local branch=`__git_ps1 "%s"`
  local pull=`git config branch.live.merge | sed -E 's=refs/heads/(.*)=\1='`
  if [[ -z $pull ]]; then
    pull=$branch
  fi

  local args=""
  local remote=""
  if [[ -z "$1" || "${1:0:2}" == "--" ]]; then
    remote=`git config branch.$branch.remote`
    if [[ -z "$remote" ]]; then
      remote=origin
    fi

    args="$@"
  else
    remote="$1"
    args="${@:2}"
  fi

  echo git push $args "$remote" "$pull"
  git push $args "$remote" "$pull"
  _beep
}

function gub () {
  git co master
  git merge bug_$1 && git br -D bug_$1 && git push origin :bug_$1
}

function gpp() {
  branch=`__git_ps1 "%s"`
  local pull=`git config branch.live.merge | sed -E 's=refs/heads/(.*)=\1='`
  if [[ -z $pull ]]; then
    pull=$branch
  fi

  if [[ -z "$1" ]]; then
    remote=`git config branch.$branch.remote`
    if [[ -z "$remote" ]]; then
      remote=origin
    fi
  else
    remote="$1"
  fi
  echo git pull "$remote" "$pull"
  git pull "$remote" "$pull"
  echo git push "$remote" "$pull"
  git push "$remote" ""$pull""
  _beep
}


export -f g
export -f give
export -f gull
export -f gush
export -f gub
export -f gpp
