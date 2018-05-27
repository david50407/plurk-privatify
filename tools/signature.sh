#!/usr/bin/env bash
# Depenencies: 
#   openssl with -hmac
#   base64

function hmac_sha1 {
  key="$1"
  data="$2"

  echo -n "$data" | openssl dgst -sha1 -hmac "$key" -binary | base64
}

hmac_sha1 "$1" "$2"
