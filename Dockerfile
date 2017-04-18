FROM php:7.0-apache

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN rm -rf /var/www/html/logs/* \
    && chown -R www-data:www-data /var/www/html

RUN a2enmod ssl
RUN a2enmod rewrite

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=SCO-100001269.ad.swiftpage.com" -keyout /etc/ssl/private/mysitename.key -out /etc/ssl/private/mysitename.crt

COPY ./web /var/www/html
COPY ./site.conf.ini /etc/apache2/sites-enabled/000-default.conf

COPY chain.crt /etc/ssl/private/
COPY TrustedRoot.crt /etc/ssl/private/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN echo "ServerName SCO-100001269.ad.swiftpage.com" >> /etc/apache2/apache2.conf
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR




