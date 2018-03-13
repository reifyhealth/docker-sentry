#!/bin/bash

# Dispose of dbs and spin down sentry-test app

SENTRY_APP_HANDLE=sentry-test

## spin down sentry
# TODO uncommone when done dev
#./scale-sentry-services 0

aptible db:deprovision --environment reify-production sentry-production-sandbox
aptible db:deprovision --environment reify-production sentry-redis-production-sandbox
