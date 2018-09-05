FROM php:7.2-apache
MAINTAINER Jordano Celestrini <jordanorc@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN a2enmod rewrite

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
		echo 'upload_max_filesize=100M'; \
		echo 'post_max_size=100M'; \
        echo 'max_execution_time = 0'; \
        echo 'memory_limit = -1'; \
} > /usr/local/etc/php/conf.d/uploads.ini

# ext curl
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev cron
RUN docker-php-ext-install curl

# ext gd
RUN apt-get install -y --no-install-recommends libfreetype6-dev libpng-dev libjpeg-dev
RUN apt-get install -y --no-install-recommends libgd-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr
RUN docker-php-ext-install gd

# ext intl 
RUN apt-get install -y --no-install-recommends libicu-dev
RUN docker-php-ext-install intl

# ext mysql 
RUN docker-php-ext-install mysqli

# ext xml xmlrpc
RUN apt-get install -y --no-install-recommends libxml2-dev
RUN docker-php-ext-install xml xmlrpc

# ext gettext mbstring soap
RUN docker-php-ext-install gettext mbstring soap

# ext zip
RUN apt-get install -y --no-install-recommends zlib1g-dev
RUN docker-php-ext-install zip

# ext iconv
RUN docker-php-ext-install iconv

# ext opcache
RUN docker-php-ext-install opcache

VOLUME /var/moodledata
VOLUME /var/www/html

EXPOSE 80 443

CMD ["apache2-foreground"]
