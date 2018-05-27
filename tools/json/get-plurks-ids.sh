#!/usr/bin/env bash
# Dependencies:
#   jq

cat - | jq -r '.[].id'
