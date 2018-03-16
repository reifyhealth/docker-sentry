#!/bin/bash
# 
# Creates a test stack for sentry:
# * creates a new redis db
# * clones the prod sentry db
# * configures the sentry test app to use those dbs
# * starts sentry _services_
# * creates an https _endpoint_

sentry_app_handle=sentry-test

PROJECT_ROOT=$(git rev-parse --show-toplevel)
$PROJECT_ROOT/scripts/test-env-scale-sentry-services.sh 0

# Create postgres db and get connection info
aptible db:clone sentry-production sentry-production-sandbox
sentry_postgres_url=`aptible db:url sentry-production-sandbox`

SENTRY_DB_NAME=$(echo $sentry_postgres_url | grep -o "[[:alnum:]]*$")
SENTRY_DB_PASSWORD=$(echo $sentry_postgres_url | awk -F"(:|@)" '{print $3}')
SENTRY_DB_USER=$(echo $sentry_postgres_url | awk -F":" '{print $2}' | awk -F"/" '{print $NF}')
SENTRY_POSTGRES_HOST=$(echo $sentry_postgres_url | awk -F"(:|@)" '{print $4}')
SENTRY_POSTGRES_PORT=$(echo $sentry_postgres_url | awk -F"(:|/)" '{print $(NF-1)}')

# Create redis db and get connection info
aptible db:create --type redis --version 3.0 --environment reify-production sentry-redis-production-sandbox
sentry_redis_url=`aptible db:url sentry-redis-production-sandbox`

SENTRY_REDIS_HOST=$(echo $sentry_redis_url | awk -F"(:|@)" '{print $(NF-1)}')
SENTRY_REDIS_PASSWORD=$(echo $sentry_redis_url | awk -F"(:|@)" '{print $3}')
SENTRY_REDIS_PORT=$(echo $sentry_redis_url | awk -F":" '{print $NF}')

echo "Setting sentry config:
SENTRY_DB_NAME:        $SENTRY_DB_NAME
SENTRY_DB_PASSWORD:    $SENTRY_DB_PASSWORD
SENTRY_DB_USER:        $SENTRY_DB_USER
SENTRY_POSTGRES_HOST:  $SENTRY_POSTGRES_HOST
SENTRY_POSTGRES_PORT:  $SENTRY_POSTGRES_PORT
SENTRY_REDIS_HOST:     $SENTRY_REDIS_HOST
SENTRY_REDIS_PASSWORD: $SENTRY_REDIS_PASSWORD
SENTRY_REDIS_PORT:     $SENTRY_REDIS_PORT"

aptible config:set --app $sentry_app_handle \
        SENTRY_DB_NAME=$SENTRY_DB_NAME \
        SENTRY_DB_PASSWORD=$SENTRY_DB_PASSWORD \
        SENTRY_DB_USER=$SENTRY_DB_USER \
        SENTRY_POSTGRES_HOST=$SENTRY_POSTGRES_HOST \
        SENTRY_POSTGRES_PORT=$SENTRY_POSTGRES_PORT \
        SENTRY_REDIS_HOST=$SENTRY_REDIS_HOST \
        SENTRY_REDIS_PASSWORD=$SENTRY_REDIS_PASSWORD \
        SENTRY_REDIS_PORT=$SENTRY_REDIS_PORT

## spin up sentry
$PROJECT_ROOT/scripts/test-env-scale-sentry-services.sh 1

# create endpoint
aptible endpoints:https:create \
        --app sentry-test \
        --default-domain \
        web

echo "Sandbox created. Sentry available at https://app-8829.on-aptible.com/"
