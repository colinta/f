if [[ -z "$NOW_TIMEZONE" ]]; then
  NOW_TIMEZONE=America/Denver
fi

function now () {
  if [[ -z "$@" ]]; then
    php -r 'echo time();'
  else
    local tz="$NOW_TIMEZONE"
    if [[ -n $2 ]]; then
      tz="$2"
    fi
    php -r "date_default_timezone_set('$tz'); echo date('$*');"
  fi
}

export -f now

