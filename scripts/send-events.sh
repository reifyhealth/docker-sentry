#!/bin/bash
# Used to send test events to a test server
#
# You must have sentry-cli installed
# https://github.com/getsentry/sentry-cli
#
# You must set:
# $SENTRY_PUBLIC_KEY
# $SENTRY_PRIVATE_KEY
# $SENTRY_PROJECT_ID

sentry_app_handle=sentry-test

sentry_config=$(aptible config --app $sentry_app_handle)

sentry_host=$(echo "$sentry_config" | grep "SENTRY_URL_PREFIX" | awk -F"//" '{print $NF}')

sentry_dsn="https://$SENTRY_PUBLIC_KEY:$SENTRY_PRIVATE_KEY@$sentry_host/$SENTRY_PROJECT_ID"

messages=$1

echo "Sending $1 events"

# unset environment variables so they're not sent to sentry
for e in $(env | grep -vE ^PATH | cut -d '=' -f 1); do
  unset $e;
done

export SENTRY_DSN=$sentry_dsn
for i in $(seq 1 $messages); do
  # use env -i so that it won't send your local env vars
  echo $(sentry-cli send-event -m "a failure") $i;
done
