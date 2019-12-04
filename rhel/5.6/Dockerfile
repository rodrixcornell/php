FROM centos/s2i-base-centos7

ARG ORACLE_LATEST=12.1

# This image provides an Apache+PHP environment for running PHP
# applications.

EXPOSE 8080
EXPOSE 8443

# Description
# This image provides an Apache 2.4 + PHP 5.6 environment for running PHP applications.
# Exposed ports:
# * 8080 - alternative port for http

ENV PHP_VERSION=5.6 \
    PHP_VER_SHORT=56 \
    NAME=php \
    PATH=$PATH:/opt/rh/rh-php56/root/usr/bin

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="Apache 2.4 with PHP ${PHP_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,${NAME},${NAME}${PHP_VER_SHORT},rh-${NAME}${PHP_VER_SHORT}" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.s2i.scripts-url="image:///usr/libexec/s2i" \
      name="centos/${NAME}-${PHP_VER_SHORT}-centos7" \
      com.redhat.component="rh-${NAME}${PHP_VER_SHORT}-docker" \
      version="${PHP_VERSION}" \
      help="For more information visit https://github.com/sclorg/s2i-${NAME}-container" \
      usage="s2i build https://github.com/sclorg/s2i-php-container.git --context-dir=${PHP_VERSION}/test/test-app centos/${NAME}-${PHP_VER_SHORT}-centos7 sample-server" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# Install Apache httpd and PHP
RUN yum install -y centos-release-scl centos-release-scl-rh && \
    INSTALL_PKGS="rh-php56 rh-php56-php rh-php56-php-mysqlnd rh-php56-php-pgsql rh-php56-php-bcmath \
                  rh-php56-php-gd rh-php56-php-intl rh-php56-php-ldap rh-php56-php-mbstring rh-php56-php-pdo \
                  rh-php56-php-pecl-memcache rh-php56-php-process rh-php56-php-soap rh-php56-php-opcache rh-php56-php-xml \
                  rh-php56-php-pecl-xdebug rh-php56-php-gmp httpd24-mod_ssl" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus --enablerepo=centos-sclo-rh-testing $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

# Oracle Instantlient
COPY ./oci/ /tmp

ENV ORACLE_INSTANTCLIENT=$ORACLE_LATEST \
    ORACLE_RPM="oracle-instantclient*rpm" \
    ORACLE_BASE=/usr/lib/oracle \
    ORACLE_HOME=/usr/lib/oracle/$ORACLE_LATEST/client64 \
    LD_LIBRARY_PATH=/usr/lib/oracle/$ORACLE_LATEST/client64/lib \
    NLS_TERRITORY=BRAZIL \
    NLS_LANG="BRAZILIAN PORTUGUESE_BRAZIL.UTF8" \
    NLS_LANGUAGE="BRAZILIAN PORTUGUESE" \
    NLS_CHARACTERSET=UTF8 \
    NLS_NCHAR_CHARACTERSET=AL32UTF8 \
    NLS_CURRENCY="R$" \
    NLS_NUMERIC_CHARACTERS=".," \
    NLS_SORT=WEST_EUROPEAN_AI \
    NLS_COMP=BINARY \
    NLS_DATE_FORMAT="RRRR-MM-DD HH24:MI:SS" \
    NLS_TIMESTAMP_FORMAT="RRRR-MM-DD HH24:MI:SS.FF"

RUN yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus --enablerepo=centos-sclo-rh-testing rh-php56-php-devel && \
    rpm -V rh-php56-php-devel && yum localinstall -y /tmp/oracle*rpm && \
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/include/oracle/$ORACLE_INSTANTCLIENT/client64 && \
    export PATH=$ORACLE_HOME/bin:$PATH && echo $PATH && \
    echo $ORACLE_HOME"/lib" | tee /etc/ld.so.conf.d/oracle.conf && ldconfig && \
    cd /tmp && curl "https://codeload.github.com/php/php-src/tar.gz/php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//")" --output "php-src-php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//").tar.gz" && tar -xzvf php-src-php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//").tar.gz && cd php-src-php-$(php -v | grep -i cli | cut -c5-10 | sed "s/-//")/ext/oci8 && \
    \
    phpize && ./configure --with-oci8=instantclient && make && make install && \
    { \
    echo "; configuration for php oracle module"; \
    echo "; priority=20"; \
    echo "extension=oci8.so"; \
    echo ; \
    echo "oci8.ping_interval = -1"; \
    echo "oci8.events = On"; \
    echo "oci8.statement_cache_size = 60"; \
    echo "oci8.default_prefetch = 300"; \
    } | tee /etc/opt/rh/rh-php${PHP_VER_SHORT}/php.d/oci8.ini && \
    php -i | grep -i oci && \
    \
    cd ../pdo_oci && \
    phpize && ./configure -with-pdo-oci=instantclient,/usr,$ORACLE_INSTANTCLIENT && \
    make && make install && \
    { \
    echo "; configuration for php oracle module"; \
    echo "; priority=20"; \
    echo "extension=pdo_oci.so"; \
    } | tee /etc/opt/rh/rh-php${PHP_VER_SHORT}/php.d/pdo_oci.ini && \
    php -i | grep -i oci && \
    yum -y clean all --enablerepo='*'

ENV PHP_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/php/ \
    APP_DATA=${APP_ROOT}/src \
    PHP_DEFAULT_INCLUDE_PATH=/opt/rh/rh-php56/root/usr/share/pear \
    PHP_SYSCONF_PATH=/etc/opt/rh/rh-php56 \
    PHP_HTTPD_CONF_FILE=rh-php56-php.conf \
    HTTPD_CONFIGURATION_PATH=${APP_ROOT}/etc/conf.d \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/opt/rh/httpd24/root/var/www \
    HTTPD_VAR_PATH=/opt/rh/httpd24/root/var \
    SCL_ENABLED=rh-php56

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# Reset permissions of filesystem to default values
RUN /usr/libexec/container-setup && rpm-file-permissions

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
