#!/usr/bin/env bash
# Dependencies:
#   jq

TIME=$(cat - | jq -Mj '.[-1].posted')
date --date="$TIME" -u +'%Y-%m-%dT%H:%M:%S'
