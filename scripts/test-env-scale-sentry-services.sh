#!/bin/bash

sentry_app_handle=sentry-test
container_count=$1
container_size=512
services=( cron worker web )

for service in "${services[@]}"
do
  aptible apps:scale $service \
          --container-count $container_count \
          --container-size  $container_size \
          --app             $sentry_app_handle
done
