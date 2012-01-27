#!/usr/bin/env bash
#----------------------------------------------
# Bookmarking for functions
#----------------------------------------------

if [[ -z "$F_PATH" ]]; then
  export F_PATH=$HOME/.f/unctions
fi

if [[ ! -d "$F_PATH" ]]; then
  mkdir -p "$F_PATH"
fi

__f_files()
{
  local files=( )
  if [[ -d "$F_PATH" ]]; then
    for file in `ls -1 "$F_PATH"` ; do
      files+=( "$F_PATH/$file" )
    done
  fi
  
  if [[ -d "$F_PATH.local" ]]; then
    for file in `ls -1 "$F_PATH.local"` ; do
      files+=( "$F_PATH.local/$file" )
    done
  fi
  echo ${files[@]}
}


function __f_init()
{
  local file
  if [[ -d "$F_PATH" ]]; then
    for file in $F_PATH/*
    do
      source $file
    done
  fi

  if [[ -d "$F_PATH.local" ]]; then
    for file in "$F_PATH.local"/*
    do
      source $file
    done
  fi
}

__f_init

function f()
{
  if [[ ! -t 1 ]]; then
    echo "$F_PATH"
  elif [[ "$#" -eq 1 ]]; then
    if [[ $1 == "-h" || $1 == "--help" ]]; then
      __f_usage
    elif [[ $1 == "-l" || $1 == "--list" ]]; then
      __f_list
    elif [[ $1 == "-e" || $1 == "--edit" ]]; then
      local f_loc="$F_PATH.sh"
      `$EDITOR $f_loc`
    else
      __f_cat $1
    fi
  elif [[ $1 == "-e" || $1 == "--edit" ]]; then
    __f_edit "$2"
  elif [[ "$#" -ge 2 ]]; then
    __f_add $1 "${@:2}"
  else
    echo "Re-reading functions"
    __f_init
  fi
}

function __f_list()
{
  local files=( )
  local file

  if [[ -d "$F_PATH" ]]; then
    for file in `ls -1 "$F_PATH"` ; do
      files+=( "$F_PATH/$file" )
    done
  fi

  if [[ -d "$F_PATH.local" ]]; then
    for file in `ls -1 "$F_PATH.local"` ; do
      files+=( "$F_PATH.local/$file" )
    done
  fi

  if [[ "${#files}" -eq 0 ]]; then
    echo "You have not set any functions."
  else
    for file in "${files[@]}" ; do
      file=$(basename $file | sed 's/\.sh$//')
      echo "$file"
    done
  fi
}

function __f_edit()
{
  local f_loc=`__f_find_mark "$1"`
  if [[ -n "$f_loc" ]]; then
    `$EDITOR $f_loc`
    __f_init
  fi
}

function __f_add()
{
  local f_loc=`__f_find_mark "$1"`

  if [[ $2 == "-" && $# -eq 2 ]]; then # remove only
    echo "Removing $1"
    rm -- $f_loc
    unset -f $1
    return
  else
    local cmd=""
    if [[ -n "$f_loc" ]]; then
      echo "Replacing $1"
      cmd="${@:2}"
    else
      echo "Adding $1"
      # TODO: check the *last* arg for -l/--local switch, and include all args between 2..n-1
      if [[ "$3" = "-l" || "$3" = "--local" ]]; then
        f_loc=$F_PATH.local/$1.sh
        cmd="$2"
      else
        f_loc=$F_PATH/$1.sh
        cmd="${@:2}"
      fi
    fi

    echo "
function $1 () {" > $f_loc
    echo "$cmd" | sed 's/^/  /' >> $f_loc
    echo "}

export -f $1
" >> $f_loc
    source $f_loc
  fi
}

function __f_cat()
{
  local f_loc=`__f_find_mark "$1"`
  if [[ -n "$f_loc" ]]; then
    cat $f_loc
  else
    echo "That function does not exist."
  fi
}

function __f_find_mark()
{
  local __f_mark=$(ls -1 $F_PATH.local/$1.sh 2>/dev/null)
  if [[ -z "$__f_mark" ]]; then
    __f_mark=$(ls -1 $F_PATH/$1.sh 2>/dev/null)
  fi
  echo $__f_mark
}

function __f_usage()
{
  cat <<HEREDOC
f, a function tracking system

Usage:
f [options] [function] [code [...]]

For ease of entering functions using `!!`, ALL arguments, not just the third, are included.

Options:
-h, --help        Show this help screen
-l, --list        List functions
-e, --edit \$fn   Use \$EDITOR to edit the function file named \$fn

Notes:
\$F_PATH is where you want your functions to be stored.  It should be in version control
\$F_PATH.local is a *local* place to store functions, and it should probably *not* be in version control
If f is run with no arguments, it will RELOAD and LIST all of the functions.
If it is given a function name, it will display that function.
If it is given a function and code, it will create that function.
If it is run AS a command, e.g. `f`, it will output \$F_PATH.

HEREDOC
}
