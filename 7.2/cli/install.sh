#!/bin/bash

set -xe
cp -rf /app/oracle*rpm /tmp

export LC_ALL=C.UTF-8 \
&& export TIMEZONE=America/Manaus \
&& echo $TIMEZONE | tee /etc/timezone \
\
&& apt-get update && apt-get install -y --no-install-recommends locales software-properties-common \
&& localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8 \
&& locale-gen pt_BR.UTF-8 && update-locale LANG=pt_BR.UTF-8 LANGUAGE=pt_BR: \
&& LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
&& apt-get install -yq --no-install-recommends php$PHP_VERSION-{bcmath,cli,curl,gd,json,mbstring,mysql,sqlite*,xml,zip} libaio1 curl alien make php$PHP_VERSION-dev \
\
&& alien --scripts --install /tmp/oracle*rpm && apt-get install -f -y --no-install-recommends \
\
&& export C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/include/oracle/$ORACLE_INSTANTCLIENT/client64 \
&& export PATH=$ORACLE_HOME/bin:$PATH && echo $PATH \
\
&& cd /tmp && curl "https://codeload.github.com/php/php-src/tar.gz/php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//")" --output "php-src-php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//").tar.gz" && tar -xzvf php-src-php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//").tar.gz && cd php-src-php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//")/ext/oci8 \
\
&& phpize && ./configure --with-oci8=instantclient && make && make install && chmod -x /usr/lib/php/*/oci8.so \
&& { \
echo "; configuration for php oracle module"; \
echo "; priority=20"; \
echo "extension=oci8.so"; \
echo ; \
echo "oci8.ping_interval = -1"; \
echo "oci8.events = On"; \
echo "oci8.statement_cache_size = 60"; \
echo "oci8.default_prefetch = 300"; \
} | tee /etc/php/$PHP_VERSION/mods-available/oci8.ini \
&& phpenmod -v $PHP_VERSION oci8 && php -i | grep -i oci \
\
&& cd ../pdo_oci \
&& phpize && ./configure -with-pdo-oci=instantclient,$LD_LIBRARY_PATH \
&& make && make install && chmod -x /usr/lib/php/*/pdo_oci.so \
&& { \
echo "; configuration for php oracle module"; \
echo "; priority=20"; \
echo "extension=pdo_oci.so"; \
} | tee /etc/php/$PHP_VERSION/mods-available/pdo_oci.ini \
&& phpenmod -v $PHP_VERSION pdo_oci && php -i | grep -i oci \
\
&& cd && apt-get purge -y curl alien gcc-7-base make php$PHP_VERSION-dev oracle-instantclient$ORACLE_INSTANTCLIENT-devel locales software-properties-common && apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/php* /tmp/oracle* /usr/lib/python3

apt-get update -y && apt-get upgrade -yq --no-install-recommends && apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
