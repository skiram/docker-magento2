FROM php:7.1-cli

RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Setup the Composer installer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_VERSION 1.6.5

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer \
 && php -r " \
    \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 && rm -rf /tmp/* /tmp/.htaccess

# Download and compile icu for intl install
RUN curl -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz \
    && tar -zxf /tmp/icu.tar.gz -C /tmp \
    && cd /tmp/icu/source \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && rm -rf /tmp/icu*

RUN apt-get update \
    && apt-get install -y \
        libpng-dev \
        libjpeg-dev \
        libpq-dev \
        libmcrypt-dev \
        libxml2-dev \
        libxslt1-dev \
        libfreetype6-dev \
        sudo \
        mysql-client \
        git \
    && rm -rf /var/lib/apt/lists/*

# Required for intl install
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr/ \
    && docker-php-ext-configure intl --with-icu-dir=/usr/local \
    && docker-php-ext-install \
        intl \
        mcrypt \
        gd \
        opcache \
        pdo \
        pdo_mysql \
        zip \
        soap \
        mbstring \
        xsl \
        bcmath

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
    } > /usr/local/etc/php/conf.d/ext-xdebug.ini.disabled \
    && mkdir /tmp/xdebug \
    && chmod 777 /tmp/xdebug

ENV XDEBUG_ENABLED false

RUN apt-get update \
    && apt-get -y install libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && rm -r /var/lib/apt/lists/*

# Blackfire Install
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# User Docker for permission managment
RUN useradd docker \
    && mkdir -p /home/docker/.composer \
    && usermod --append --groups sudo docker \
    && chown -R docker:docker /home/docker \
    && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo 'docker:secret' | chpasswd

WORKDIR /var/www/html

COPY entrypoint.sh /usr/local/bin/docker-php-entrypoint
