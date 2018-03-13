#!/bin/bash

# Dispose of dbs and spin down sentry-test app
PROJECT_ROOT=$(git rev-parse --show-toplevel)

$PROJECT_ROOT/scripts/test-env-scale-sentry-services.sh 0
aptible db:deprovision --environment reify-production sentry-production-sandbox
aptible db:deprovision --environment reify-production sentry-redis-production-sandbox
