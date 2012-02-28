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


function f()
{
  if [[ -n "$1" && "${1:0:2}" = "--" ]]; then
    cmd="__f_${1:2}"
    if [[ -z `type -t $cmd` ]]; then
      echo "Unknown command \"f $1\"" >&2
      return 1
    fi

    $cmd "${@:2}"
    return $?
  elif [[ -n "$1" && "${1:0:1}" = "-" ]]; then
    cmd="__f_${1:1}"
    if [[ -z `type -t $cmd` ]]; then
      echo "Unknown command \"f $1\"" >&2
      return 1
    fi

    $cmd "${@:2}"
    return $?
  elif [[ "$#" -eq 0 ]]; then
    # no args:
    __f_init
  elif [[ "$#" -eq 1 ]]; then
    # one arg, and it wasn't a command
    __f_show "$1"
  else
    __f_add "${@:1}"
  fi
}


function __f_init()
{
  #  outputs F_PATH when output is not to stdout,
  #  otherwise reloads functions by source all
  # the function files
  if [[ ! -t 1 ]]; then
    echo "$F_PATH"
    return
  fi

  local file
  if [[ "$1" != '-q' ]]; then
    echo "Reloading functions" >&2
  fi

  if [[ -d "$F_PATH" ]]; then
    for file in $F_PATH/*.sh
    do
      source $file
    done
  fi

  if [[ -d "$F_PATH.local" ]]; then
    for file in "$F_PATH.local"/*.sh
    do
      source $file
    done
  fi
}

function __f_i() {
  __f_init "$@"
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

function __f_l() {
  __f_list "$@"
}


function __f_edit()
{
  if [[ -z "$1" ]]; then
    # edits f.sh file itself when no arg is given
    local f_loc="$F_PATH.sh"
    `$EDITOR $f_loc`
  else
    local f_loc=`__f_find_mark "$1"`
    if [[ -n "$f_loc" ]]; then
      `$EDITOR $f_loc`
      __f_init -q
    fi
  fi
}

function __f_e() {
  __f_edit "$@"
}


function __f_remove()
{
  local f_loc=`__f_find_mark "$1"`

  echo "Removing $1"
  rm -- "$f_loc"
  unset -f "$1"
  return
}

function __f_r() {
  __f_remove "$@"
}


function __f_add()
{
  local f_loc=`__f_find_mark "$1"`

  if [[ $2 == "-" && $# -eq 2 ]]; then # remove only
    echo "Removing $1"
    rm -- "$f_loc"
    unset -f "$1"
    return
  else
    local cmd=""
    if [[ -n "$f_loc" ]]; then
      echo "Replacing $1"
      cmd="${@:2}"
    else
      echo "Adding $1"
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

function __f_a() {
  __f_add "$@"
}

function __f_alias() {
  local fn="$1"
  local cmd="${@:2}"
  if [[ -z "$fn" || -z "$cmd" ]]; then
    echo 'Usage: f --alias fn cmd' >&2
    echo "  f --alias l1 'ls -1'" >&2
    return 1
  fi
  __f_add "$fn" command "$cmd" '$@'
}


function __f_show()
{
  # when output is not to stdout, outputs the location
  # of the function
  local f_loc=`__f_find_mark "$1"`
  if [[ -z "$f_loc" ]]; then
    echo "That function does not exist." >&2
  elif [[ ! -t 1 ]]; then
    echo "$f_loc"
  else
    cat $f_loc
  fi
}

function __f_s() {
  __f_show "$@"
}


function __f_find_mark()
{
  local __f_mark=$(ls -1 $F_PATH.local/$1.sh 2>/dev/null)
  if [[ -z "$__f_mark" ]]; then
    __f_mark=$(ls -1 $F_PATH/$1.sh 2>/dev/null)
  fi
  echo $__f_mark
}

function __f_help()
{
  cat <<HEREDOC
f, a function tracking system

Usage:
f [options] [function] [code [...]]

For ease of entering functions using `!!`, ALL arguments, not just the third, are included.

Options:
-a, --add \$fn [code]   Adds or replaces the function '\$fn' with [code].
                        Multiple [code] arguments are supported.
                        This is the default command when 2 or more arguments are passed.
--alias \$fn \$cmd      Creates a "command alias".
                        Equivaluent to \`f --add "\$fn" 'command \$cmd "\$@"'
-s, --show \$fn         Shows the function file \$fn.
                        This is the default command when 1 argument is passed.
-l, --list              List functions
-e, --edit \$fn         Use \$EDITOR to edit the function file named \$fn
-r, --remove \$fn       Removes the function '\$fn'.
-h, --help              Show this help screen.
-i, --init              Reloads the functions.
                        Default command when no arguments are passed.

Notes:
\$F_PATH is where you want your functions to be stored.  This folder should be in version control.
\$F_PATH.local is a *local* place to store functions, and it should probably *not* be in version control

If f is run with no arguments, it will RELOAD all of the functions,
  or output FPATH if output is redirected.
If it is given a function name, it will display that function,
  or output the path to that function if output is redirected.
If it is given a function and code, it will create that function.

f should not be used to store executables written in other languages.  For that, add a bin/ folder
somewhere and add it to your PATH.

HEREDOC
}

function __f_h() {
  __f_help
}

# finally: initilize the f folder.
__f_init -q
