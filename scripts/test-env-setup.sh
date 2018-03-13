#!/bin/bash

# Creates a test stack for sentry:
# creates a new redis db,
# clones the prod sentry db,
# and configures the sentry test app to use them
SENTRY_APP_HANDLE=sentry-test

## spin down sentry so we can make config changes
# TODO uncommone when done dev
# ./scale-sentry-services 0

# TODO uncommone when done dev
aptible db:clone sentry-production sentry-production-sandbox
sentry_postgres_url=`aptible db:url sentry-production-sandbox`



aptible db:create --type redis --version 3.0 --environment reify-production sentry-redis-production-sandbox
sentry_redis_url=`aptible db:url sentry-redis-production-sandbox`

