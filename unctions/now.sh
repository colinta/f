
function now () {
  if [[ -z "$@" ]]; then
    php -r 'echo time();'
  else
    php -r "date_default_timezone_set('America/Denver'); echo date('$*');"
  fi
}

export -f now

