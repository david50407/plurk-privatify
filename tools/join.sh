#!/usr/bin/env bash
IFS="$1"
shift

echo -n "$1"
shift
printf "%s" "${@/#/$IFS}"
