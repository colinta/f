
function qs () {
  if [[ -z "$1" ]]; then
    echo "Usage: qs [pattern]"
    return 1
  fi
  string=$1
  pattern="*$(echo $string | sed "s/\(.\)/\1*/g")"
  files=`find . -ipath "$pattern" -type f | ned ^./ ""`
  if [[ -n "$files" ]]; then
    slen=${#string}
    for file in $files ; do
      flen=${#file}
      i=0
      j=0
      pos=0
      substr=""
      while [[ $i -lt $slen ]]; do
        sc=${string:$i:1}
        fc=${file:$j:1}
        while [[ $fc != $sc ]]; do
          echo -n $fc
          j=$(($j + 1))
          fc=${file:$j:1}
        done
        echo -e -n "\033[1m$sc\033[0m"
        i=$(($i + 1))
        j=$(($j + 1))
      done
      echo ${file:$j}
    done
  fi
}

export -f qs

