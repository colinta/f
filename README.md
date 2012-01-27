# f, a function tracking system

## What, Why?
Having a dotfiles repository is the first step to having a consistent commandline interface wherever you login.  `f` adds to that by having a place to add and remove shell functions.  These can be as simple as aliases (`f l1 'command ls -1 "$@"'`) or full blown shell programs.  Either way, you can then cd `f`, `git add -A`, `git ci -m "new functions"`, `git push`.

Or, better yet, store that as one `f` command:

    $ f commitf 'pushd `f`
    > git add -A
    > if [[ $# -gt 0 ]]; then
    >   git ci -m "$1"
    > else
    >   git ci -m
    > fi
    > git push --quiet && echo "Pushed" || echo "Could not push.  Try pulling first"
    > popd'
    Adding commitf
    $ commitf

## Usage:
      f [options] [function] [code [...]]
      
For ease of entering functions using `!!`, ALL arguments, not just the third, are included.

## Options:
      -h, --help        Show this help screen
      -l, --list        List functions
      -e, --edit $fn    Use \$EDITOR to edit the function file named $fn
      

## Notes:
`$F_PATH` is where you want your functions to be stored.  It should be in version control
`$F_PATH.local` is a *local* place to store functions, and it should probably *not* be in version control
If f is run with no arguments, it will RELOAD and LIST all of the functions.
If it is given a function name, it will display that function.
If it is given a function and code, it will create that function.
If it is run AS a command, e.g. `f`, it will output `$F_PATH`.

## Examples:
    $ l1
      -bash: l1: command not found
    $ f l1 'command ls -1 "$@"'
      Adding l1
    $ f --list
      ...
      l1
      ...
    $ f l1
      
      function l1 () {
        command ls -1 "$@"
      }

      export -f l1

    $ l1
      README.md
      f.sh
      unctions
    $ f l1 -
      Removing l1
    $ l1
      -bash: l1: command not found

## TODO

* Support for functions that are executable scripts (python, ruby, etc)
* Add support for `f --help function`