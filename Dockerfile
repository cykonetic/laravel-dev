FROM php:apache

LABEL Author="Nicholai Bush <nicholaibush@yahoo.com>"

ENV APACHE_LOG_DIR /var/log/apache2

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - &&\
    apt-get update &&\
    apt-get install --no-install-recommends -y apt-utils &&\
    apt-get install --no-install-recommends -y nodejs git zip libicu-dev libzip-dev libhiredis-dev &&\
    docker-php-ext-install bcmath opcache intl zip pdo_mysql &&\
    pecl install -o -f xdebug &&\
    pecl install -o -f redis &&\
    docker-php-ext-enable xdebug redis &&\
    a2enmod rewrite &&\
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer &&\
    rm -rf /tmp/pear &&\
    apt-get autoremove -y &&\
    apt-get autoclean -y

COPY configs/vhost.conf $APACHE_CONFDIR/sites-available/000-default.conf
# COPY config/php.ini $PHP_INI_DIR/
COPY configs/xdebug.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv/app