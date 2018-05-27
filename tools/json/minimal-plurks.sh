#!/usr/bin/env bash
# Dependencies:
#   jq

cat - | jq -Mcj '[.[] | { id: .plurk_id, limited_to, posted }]'
