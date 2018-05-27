#!/usr/bin/env bash
DIR=$(dirname $0)
TOOLS=$DIR/..
JOIN=$TOOLS/join.sh

function quote-param-value {
  echo "$1" | sed -r 's/=(.+)/="\1"/'
}

function quote-params {
  for item in $@; do
    echo $(quote-param-value $item)
  done
}

ENDPOINT=$1
shift

PARAMS=$(quote-params "realm=$ENDPOINT" $@)

echo -n 'Authorization: OAuth '
$JOIN ', ' ${PARAMS[*]}
