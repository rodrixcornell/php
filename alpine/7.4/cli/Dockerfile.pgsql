
ARG distribution=""
ARG variant=""
ARG php_version=""

FROM php:${php_version:+${php_version}-}${variant:+${variant}-}${distribution:+${distribution}}

MAINTAINER Rodrigo Cabral <rodrixcornell@gmail.com.br>

ENV TZ="America/Manaus"

RUN set -xe \
&& apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
freetype-dev \
libjpeg-turbo-dev \
libpng-dev \
libzip-dev \
icu-dev \
postgresql-dev \
git \
tzdata \
&& echo $TZ > /etc/timezone \
&& cp -rf /usr/share/zoneinfo/$TZ /etc/localtime \
&& date \
&& docker-php-source extract \
&& docker-php-ext-configure pgsql --with-pgsql=/usr/include/ \
&& docker-php-ext-configure pdo_pgsql --with-pdo-pgsql=/usr/include/ \
&& docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" bcmath exif intl gd pgsql pdo_pgsql \
&& docker-php-ext-enable bcmath exif intl gd pgsql pdo_pgsql \
&& docker-php-source delete \
&& curl -fsSL https://getcomposer.org/installer | php \
&& find / -name "composer.phar" -exec mv -fv {} /usr/local/bin/composer \; \
&& chmod +x /usr/local/bin/composer \
&& composer config --global http-basic.gitlab.com ___token___ UxTd434L7z5YyPyqmxYf

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# Override with custom pgsql settings
# COPY config/pgsql.ini $PHP_INI_DIR/conf.d/
# COPY config/pdo_pgsql.ini $PHP_INI_DIR/conf.d/