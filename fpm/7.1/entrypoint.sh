#!/bin/sh
set -e

XDEBUG_INI_FILE="/usr/local/etc/php/conf.d/ext-xdebug.ini"
XDEBUG_INI_FILE_DIS="${XDEBUG_INI_FILE}.disabled"

if [ "$XDEBUG_ENABLED" = "true" ]; then
    if [ -f "$XDEBUG_INI_FILE_DIS" ]; then
        mv $XDEBUG_INI_FILE_DIS $XDEBUG_INI_FILE
    fi
else
    if [ -f "$XDEBUG_INI_FILE" ]; then
        mv $XDEBUG_INI_FILE $XDEBUG_INI_FILE_DIS
    fi
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

exec "$@"