#!/usr/bin/env bash

# set -xe
echo -e "buildDocker.sh\r";

export $(egrep -v '^#' .env | xargs)

IMAGE_NAME="rodrixcornell/php:$(echo $php_version | cut -c1-3)"

IMAGE_BUILD="--build-arg php_version=${php_version} --build-arg variant=${variant} --build-arg codename=${codename} --build-arg release=${release} --build-arg distribution=${distribution}"

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
--tag $IMAGE_NAME-${variant}-${codename} \
--tag $IMAGE_NAME-${variant} \
--tag $IMAGE_NAME-${codename} \
--tag $IMAGE_NAME \
--tag rodrixcornell/php:${variant}-${codename} \
--tag rodrixcornell/php:${variant} \
--tag rodrixcornell/php:${codename} \
--tag rodrixcornell/php:latest \
--file Dockerfile .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-mysql-${variant}-${codename} \
--tag $IMAGE_NAME-mysql-${variant} \
--tag $IMAGE_NAME-mysql-${codename} \
--tag $IMAGE_NAME-mysql \
--tag rodrixcornell/php:mysql-${codename} \
--tag rodrixcornell/php:mysql \
--file Dockerfile.mysql .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-pgsql-${variant}-${codename} \
--tag $IMAGE_NAME-pgsql-${variant} \
--tag $IMAGE_NAME-pgsql-${codename} \
--tag $IMAGE_NAME-pgsql \
--tag rodrixcornell/php:pgsql-${codename} \
--tag rodrixcornell/php:pgsql \
--file Dockerfile.pgsql .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-oci-${variant}-${codename} \
--tag $IMAGE_NAME-oci-${variant} \
--tag $IMAGE_NAME-oci-${codename} \
--tag $IMAGE_NAME-oci \
--tag rodrixcornell/php:oci-${codename} \
--tag rodrixcornell/php:oci \
--file Dockerfile.oracle .

docker push $IMAGE_NAME-${variant}-${codename} && \
docker push $IMAGE_NAME-${variant} && \
docker push $IMAGE_NAME-${codename} && \
docker push $IMAGE_NAME && \
docker push rodrixcornell/php:${variant}-${codename} && \
docker push rodrixcornell/php:${variant} && \
docker push rodrixcornell/php:${codename} && \
docker push rodrixcornell/php:latest

docker push $IMAGE_NAME-mysql-${variant}-${codename} && \
docker push $IMAGE_NAME-mysql-${variant} && \
docker push $IMAGE_NAME-mysql-${codename} && \
docker push $IMAGE_NAME-mysql && \
docker push rodrixcornell/php:mysql-${codename} && \
docker push rodrixcornell/php:mysql

docker push $IMAGE_NAME-pgsql-${variant}-${codename} && \
docker push $IMAGE_NAME-pgsql-${variant} && \
docker push $IMAGE_NAME-pgsql-${codename} && \
docker push $IMAGE_NAME-pgsql && \
docker push rodrixcornell/php:pgsql-${codename} && \
docker push rodrixcornell/php:pgsql

docker push $IMAGE_NAME-oci-${variant}-${codename} && \
docker push $IMAGE_NAME-oci-${variant} && \
docker push $IMAGE_NAME-oci-${codename} && \
docker push $IMAGE_NAME-oci && \
docker push rodrixcornell/php:oci-${codename} && \
docker push rodrixcornell/php:oci