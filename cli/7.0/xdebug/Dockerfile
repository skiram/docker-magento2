FROM dragonbleu/magento2-php:7.1-cli

# XDEBUG Install
RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear \
    && { \
        echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)"; \
        echo "xdebug.remote_enable=1"; \
        echo "xdebug.profiler_enable_trigger=1"; \
        echo "xdebug.profiler_output_dir=/tmp/xdebug"; \
        echo "xdebug.trace_enable_trigger=1"; \
        echo "xdebug.trace_output_dir=/tmp/xdebug"; \
    } > /usr/local/etc/php/conf.d/ext-xdebug.ini \
    && mkdir /tmp/xdebug \
    && chmod 777 /tmp/xdebug
