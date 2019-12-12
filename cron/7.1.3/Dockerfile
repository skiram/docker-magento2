FROM dragonbleu/magento2-php:7.1.3-cli

RUN apt-get update \
    && apt-get install -y cron rsyslog \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN touch /var/log/cron.log

ENV MAGE_ROOT /var/www/html

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD cron && tail -f -n0 /var/log/cron.log