#!/bin/bash
#
# * Disposes of postgres and redis sandbox dbs
# * Turns off the web, cron, and worker services for sentry-test
# * Removes the https web endpoint

sentry_app_handle=sentry-test

PROJECT_ROOT=$(git rev-parse --show-toplevel)

# spin down sentry-test app workers
$PROJECT_ROOT/scripts/test-env-scale-sentry-services.sh 0

# remove databases
aptible db:deprovision --environment reify-production sentry-production-sandbox
aptible db:deprovision --environment reify-production sentry-redis-production-sandbox

# remove web endpoint
endpoint_hostname=$(aptible endpoints:list --app $sentry_app_handle | grep Hostname | awk -F" " '{print $NF}')
aptible endpoints:deprovision --app $sentry_app_handle $endpoint_hostname
