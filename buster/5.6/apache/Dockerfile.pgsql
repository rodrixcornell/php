
ARG distribution=""
ARG release=""
ARG codename=""
ARG variant=""
ARG php_version=""

FROM php:${php_version:+${php_version}-}${variant:+${variant}-}${codename:+${codename}}

MAINTAINER Rodrigo Cabral <rodrixcornell@gmail.com.br>

ENV TZ="America/Manaus" \
LC_ALL="C.UTF-8" \
LANG="pt_BR.utf8" \
LANGUAGE="pt_BR:pt"

RUN set -xe \
&& a2enmod rewrite headers expires \
&& apt-get update -y && apt-get upgrade -yq --no-install-recommends \
&& apt-get install -y --no-install-recommends git locales software-properties-common \
&& echo $TZ | tee /etc/timezone \
&& cp -rf /usr/share/zoneinfo/$TZ /etc/localtime \
&& localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8 \
&& locale-gen pt_BR.UTF-8 \
&& apt-get install -y --no-install-recommends \
libfreetype6-dev \
libjpeg-dev \
libpng-dev \
libicu-dev \
libpq-dev \
&& rm -rf /var/lib/apt/lists/* \
\
&& docker-php-source extract \
&& docker-php-ext-configure intl \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-configure pgsql --with-pgsql=/usr/include/ \
&& docker-php-ext-configure pdo_pgsql --with-pdo-pgsql=/usr/include/ \
&& docker-php-ext-install -j$(nproc) bcmath exif intl gd pgsql pdo_pgsql \
&& docker-php-ext-enable bcmath exif intl gd pgsql pdo_pgsql \
&& docker-php-source delete \
&& apt-get purge -y locales software-properties-common && apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && rm -rf /usr/lib/python3 \
&& apt-get update -y && apt-get upgrade -yq --no-install-recommends && apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# Override with custom pgsql settings
# COPY config/pgsql.ini $PHP_INI_DIR/conf.d/
# COPY config/pdo_pgsql.ini $PHP_INI_DIR/conf.d/