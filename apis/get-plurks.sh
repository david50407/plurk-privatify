#!/usr/bin/env bash
DIR=$(dirname $0)
TOOLS=$DIR/../tools

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

APP_TOKEN=''
APP_SECRET=''
TOKEN=''
SECRET=''
OFFSET=false
LIMIT=20

ENV_FILE="$DIR/../.env"
[ -f "$ENV_FILE" ] && source "$ENV_FILE"

while true; do
  case "$1" in
    -h | --help ) usage; exit 0 ;;
         --app ) APP_TOKEN="$2" ;;
         --app-secret ) APP_SECRET="$2" ;;
    -t | --token ) TOKEN="$2" ;;
    -s | --secret ) SECRET="$2" ;;
    -o | --offset ) OFFSET="$($TOOLS/urlencode.sh "$2")" ;;
    -l | --limit ) LIMIT="$2" ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
  shift 2
done

METHOD=POST
ENDPOINT="https://www.plurk.com/APP/Timeline/getPlurks"

QUERIES=(
  "limit=$LIMIT"
  filter=my
  minimal_data=true
  minimal_user=true
)
[ "$OFFSET" != "false" ] && QUERIES+=("offset=$OFFSET")

OAUTH_PARAMS=(
  "oauth_consumer_key=$APP_TOKEN"
  "oauth_token=$TOKEN"
  "oauth_nonce=$($TOOLS/nonce.sh)"
  "oauth_timestamp=$($TOOLS/timestamp.sh)"
  "oauth_signature_method=HMAC-SHA1"
  "oauth_version=1.0"
)

OAUTH_SBS=$($TOOLS/oauth/generate-signature-base-string.sh $METHOD $ENDPOINT ${QUERIES[*]} ${OAUTH_PARAMS[*]})
OAUTH_SIGNED=$($TOOLS/signature.sh "$APP_SECRET&$SECRET" "$OAUTH_SBS")

OAUTH_PARAMS+=(
  "oauth_signature=$($TOOLS/urlencode.sh "$OAUTH_SIGNED")"
)

OAUTH_HEADER=$($TOOLS/oauth/generate-header.sh $ENDPOINT ${OAUTH_PARAMS[*]})

curl -X "$METHOD" \
  -d "$($TOOLS/join.sh '&' ${QUERIES[*]})" \
  -H "$OAUTH_HEADER" \
  "$ENDPOINT"
