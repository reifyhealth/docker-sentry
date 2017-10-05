# Docker Sentry

This repo is derived from [getsentry/docker-sentry](https://github.com/getsentry/docker-sentry/tree/master/8.20).

These are the modifications that were made to serve our needs.
1.  Use a more recent debian version for security reasons
1.  Default the filestore to S3 so that source maps could be supported in our deployment infrastructure.

## Installation and Usage

Setting this up requires setting the following env vars.

**APTIBLE CONFIG**
* FORCE_SSL - always redirect to SSL connect

**SENTRY SYSTEM CONFIG**
* SENTRY_PROJECT - your sentry project name
* SENTRY_USE_SSL - set to TRUE for Sentry to enforce SSL connections
* SENTRY_SECRET_KEY - a randomly generated 32 bit key (recommend using sentry 'generate-secret-key')
* SENTRY_URL_PREFIX - URL where Sentry is hosted

**POSTGRES CONFIG**
* SENTRY_DB_NAME - postgres database name
* SENTRY_DB_PASSWORD - postgres database password
* SENTRY_DB_USER - postgres database user
* SENTRY_POSTGRES_HOST - postgres host
* SENTRY_POSTGRES_PORT - postgres port

**EMAIL CONFIG**
* SENTRY_SERVER_EMAIL - email address
* SENTRY_EMAIL_HOST - email host
* SENTRY_EMAIL_PASSWORD - email passowrd
* SENTRY_EMAIL_USER - email user
* SENTRY_EMAIL_USE_TLS - whether to use TLS for email

**REDIS**
* SENTRY_REDIS_HOST - redis host
* SENTRY_REDIS_PASSWORD - redis password
* SENTRY_REDIS_PORT - redis port

**FILESTORE**
* AWS_ACCESS_KEY_ID - AWS access ID
* AWS_SECRET_ACCESS_KEY - AWS access key
* AWS_S3_BUCKET_NAME - AWS bucket name

## Configuration files

`sentry.conf.py` contains the logic for how the env vars are feed into Sentry.

`config.yml` are hard-coded configurations that will overwrite the env vars.

`requirements.txt` define the list of Sentry add-ons.

## Testing docker image

TBD

