#!/usr/bin/env bash
DIR=$(dirname $0)
APIS=$DIR/apis
TOOLS=$DIR/tools

function usage {
  echo "usage: $0 [options]
    -h,        --help              Print usage
               --app=token         OAuth App token
               --app-secret=secret OAuth App token secret
    -t token,  --token=token       OAuth token
    -s secret, --secret=secret     OAuth token secret
    -o offset, --offset=offset     Fetch plurks older than offset, formatted as '2009-6-20T21:55:34'
    -l limit,  --limit=limit       Fetch limit (default: 20)
  "
}

OPTS=`getopt -o ht:s:o:l: --long help,app:,app-secret:,token:,secret:,offset:,limit: -n "$0" -- "$@"`
if [ $? != 0 ] ; then usage >&2 ; exit 1 ; fi

eval set -- "$OPTS"

OPTIONS=()
LIST_OPTIONS=()

while true; do
  case "$1" in
    -h | --help ) usage; exit 0 ;;
         --app ) OPTIONS+=(--app="$2") ;;
         --app-secret ) OPTIONS+=(--app-secret="$2") ;;
    -t | --token ) OPTIONS+=(--token="$2") ;;
    -s | --secret ) OPTIONS+=(--secret="$2") ;;
    -o | --offset ) LIST_OPTIONS+=(--offset="$2") ;;
    -l | --limit ) LIST_OPTIONS+=(--limit="$2") ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
  shift 2
done

PLURKS_JSON=$($APIS/get-plurks.sh ${OPTIONS[*]} ${LIST_OPTIONS[*]} 2>/dev/null | jq -Mcj '[.plurks[]]' | $TOOLS/json/minimal-plurks.sh)

NEEDS_TO_BE_MODIFIED=$(echo $PLURKS_JSON | $TOOLS/json/filter-no-limitation-plurks.sh | $TOOLS/json/get-plurks-ids.sh)
OLDSET_TIMESTAMP=$(echo $PLURKS_JSON | $TOOLS/json/get-oldest-plurk-timestamp.sh)

for id in $NEEDS_TO_BE_MODIFIED; do
  echo -n "${id}..."
  $APIS/plurk-edit.sh ${OPTIONS[*]} --limit-to="[0]" "$id" >/dev/null 2>/dev/null
  [ $? != 0 ] && echo "Failed" || echo "Succssed"
done

echo
echo "Next offset: $OLDSET_TIMESTAMP"
