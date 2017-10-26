FROM composer:1.5

ARG M2_USERNAME
ARG M2_PASSWORD

RUN COMPOSER_AUTH="{\"http-basic\": {\"repo.magento.com\": {\"username\": \"${M2_USERNAME}\", \"password\": \"${M2_PASSWORD}\"}}}" \
    composer create-project --repository=https://repo.magento.com magento/marketplace-eqp magento-coding-standard

ENV PATH="/app/magento-coding-standard/vendor/bin/:${PATH}"