#!/bin/sh

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

{ \
    echo "* * * * * docker /usr/local/bin/php ${MAGE_ROOT}/bin/magento cron:run 2>&1 | grep -v Ran jobs by schedule >> ${MAGE_ROOT}/var/log/cron.log"; \
    echo "* * * * * docker /usr/local/bin/php ${MAGE_ROOT}/update/cron.php >> ${MAGE_ROOT}/var/log/cron.log"; \
    echo "* * * * * docker /usr/local/bin/php ${MAGE_ROOT}/bin/magento setup:cron:run >> ${MAGE_ROOT}/var/log/cron.log"; \
} > /etc/cron.d/magento-cron

echo "cron.* /var/log/cron.log" > /etc/rsyslog.d/cron.conf
service rsyslog start

exec "$@"
