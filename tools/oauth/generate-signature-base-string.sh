#!/usr/bin/env bash
DIR=$(dirname $0)
TOOLS=$DIR/..
JOIN=$TOOLS/join.sh
ENCODE=$TOOLS/urlencode.sh

function sort_parmas {
  $JOIN $'\n' $@ | sort -dt '=' -k 1 -
}

METHOD="$1"
ENDPOINT="$2"
shift 2
PARAMS=$($JOIN '&' $(sort_parmas $@))

$JOIN '&' "$($ENCODE $METHOD)" "$($ENCODE $ENDPOINT)" "$($ENCODE $PARAMS)"
