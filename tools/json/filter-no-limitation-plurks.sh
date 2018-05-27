#!/usr/bin/env bash
# Dependencies:
#   jq

cat - | jq -Mcj '[.[] | select(.limited_to == null)]'
