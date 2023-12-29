#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function fvd_main () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?
  exec </dev/null

  local DEPS='
    s~\s+~ ~g
    /^[A-Za-z0-9._-]+:$/p
    s~^ version:\s+([0-9.]+)$~=\1~p
    '
  DEPS="$(sed -nrf <(echo "$DEPS") -- ../videojs-dependencies.yml)"
  DEPS="${DEPS//:$'\n'=/@}"
  DEPS="$(<<<"$DEPS" grep -Fe '@')"
  [ -n "$DEPS" ] || return 4$(echo "E: Found no dependencies!" >&2)
  DEPS="${DEPS//$'\n'/ }"

  local DEST='../assets/videojs'
  mkdir --parents -- "$DEST"
  local NPM_CMD=( npm pack --verbose -- $DEPS )
  echo "D: cd -- $DEST && ${NPM_CMD[*]}"
  cd -- "$DEST" || return $?
  "${NPM_CMD[@]}" || return $?

  echo "D: Gonna unpack:"
}










fvd_main "$@"; exit $?
