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

export SENTRY_DSN="https://$SENTRY_PUBLIC_KEY:$SENTRY_PRIVATE_KEY@$sentry_host/$SENTRY_PROJECT_ID"
echo $SENTRY_DSN

for i in $0; do
  sentry-cli send-event -m "a failure"
done
