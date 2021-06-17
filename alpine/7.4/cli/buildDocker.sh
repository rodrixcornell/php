#!/usr/bin/env bash

# set -xe
echo -e "buildDocker.sh\r";

export $(egrep -v '^#' .env | xargs)

IMAGE_NAME="rodrixcornell/php:$(echo $php_version | cut -c1-3)"

IMAGE_BUILD="--build-arg php_version=${php_version} --build-arg variant=${variant} --build-arg distribution=${distribution}"

# Proxy settings
PROXY_SETTINGS=""
if [ "${http_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg http_proxy=${http_proxy}"
fi

if [ "${https_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg https_proxy=${https_proxy}"
fi

if [ "${ftp_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg ftp_proxy=${ftp_proxy}"
fi

if [ "${no_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg no_proxy=${no_proxy}"
fi

if [ "$PROXY_SETTINGS" != "" ]; then
  echo "Proxy settings were found and will be used during the build."
fi

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-${variant}-${distribution} \
--tag $IMAGE_NAME-${variant} \
--tag $IMAGE_NAME-${distribution} \
--tag $IMAGE_NAME \
--tag rodrixcornell/php:${variant}-${distribution} \
--tag rodrixcornell/php:${variant} \
--tag rodrixcornell/php:${distribution} \
--tag rodrixcornell/php:latest \
--file Dockerfile .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-mysql-${variant}-${distribution} \
--tag $IMAGE_NAME-mysql-${variant} \
--tag $IMAGE_NAME-mysql-${distribution} \
--tag $IMAGE_NAME-mysql \
--tag rodrixcornell/php:mysql-${distribution} \
--tag rodrixcornell/php:mysql \
--file Dockerfile.mysql .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-pgsql-${variant}-${distribution} \
--tag $IMAGE_NAME-pgsql-${variant} \
--tag $IMAGE_NAME-pgsql-${distribution} \
--tag $IMAGE_NAME-pgsql \
--tag rodrixcornell/php:pgsql-${distribution} \
--tag rodrixcornell/php:pgsql \
--file Dockerfile.pgsql .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-oci-${variant}-${distribution} \
--tag $IMAGE_NAME-oci-${variant} \
--tag $IMAGE_NAME-oci-${distribution} \
--tag $IMAGE_NAME-oci \
--tag rodrixcornell/php:oci-${distribution} \
--tag rodrixcornell/php:oci \
--file Dockerfile.oracle .

docker push $IMAGE_NAME-${variant}-${distribution} && \
docker push $IMAGE_NAME-${variant} && \
docker push $IMAGE_NAME-${distribution} && \
docker push $IMAGE_NAME && \
docker push rodrixcornell/php:${variant}-${distribution} && \
docker push rodrixcornell/php:${variant} && \
docker push rodrixcornell/php:${distribution} && \
docker push rodrixcornell/php:latest

docker push $IMAGE_NAME-mysql-${variant}-${distribution} && \
docker push $IMAGE_NAME-mysql-${variant} && \
docker push $IMAGE_NAME-mysql-${distribution} && \
docker push $IMAGE_NAME-mysql && \
docker push rodrixcornell/php:mysql-${distribution} && \
docker push rodrixcornell/php:mysql

docker push $IMAGE_NAME-pgsql-${variant}-${distribution} && \
docker push $IMAGE_NAME-pgsql-${variant} && \
docker push $IMAGE_NAME-pgsql-${distribution} && \
docker push $IMAGE_NAME-pgsql && \
docker push rodrixcornell/php:pgsql-${distribution} && \
docker push rodrixcornell/php:pgsql

docker push $IMAGE_NAME-oci-${variant}-${distribution} && \
docker push $IMAGE_NAME-oci-${variant} && \
docker push $IMAGE_NAME-oci-${distribution} && \
docker push $IMAGE_NAME-oci && \
docker push rodrixcornell/php:oci-${distribution} && \
docker push rodrixcornell/php:oci