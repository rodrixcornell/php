#!/usr/bin/env bash

# set -xe
echo -e "buildDocker.sh\r";

export $(egrep -v '^#' .env | xargs)

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

IMAGE_NAME="rodrixcornell/php:$(echo $php_version | cut -c1-3)"

IMAGE_BUILD="--build-arg php_version=${php_version} --build-arg variant=${variant} --build-arg codename=${codename} --build-arg release=${release} --build-arg distribution=${distribution}"

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-cli-buster \
--tag $IMAGE_NAME-cli \
--tag $IMAGE_NAME-buster \
--tag $IMAGE_NAME \
--file Dockerfile .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-mysql-cli-buster \
--tag $IMAGE_NAME-mysql-cli \
--tag $IMAGE_NAME-mysql-buster \
--tag $IMAGE_NAME-mysql \
--file Dockerfile.mysql .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-oci-cli-buster \
--tag $IMAGE_NAME-oci-cli \
--tag $IMAGE_NAME-oci-buster \
--tag $IMAGE_NAME-oci \
--file Dockerfile.oracle .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-pgsql-cli-buster \
--tag $IMAGE_NAME-pgsql-cli \
--tag $IMAGE_NAME-pgsql-buster \
--tag $IMAGE_NAME-pgsql \
--file Dockerfile.pgsql .

docker push $IMAGE_NAME-cli-buster && \
docker push $IMAGE_NAME-cli && \
docker push $IMAGE_NAME-buster && \
docker push $IMAGE_NAME

docker push $IMAGE_NAME-mysql-cli-buster && \
docker push $IMAGE_NAME-mysql-cli && \
docker push $IMAGE_NAME-mysql-buster && \
docker push $IMAGE_NAME-mysql

docker push $IMAGE_NAME-oci-cli-buster && \
docker push $IMAGE_NAME-oci-cli && \
docker push $IMAGE_NAME-oci-buster && \
docker push $IMAGE_NAME-oci

docker push $IMAGE_NAME-pgsql-cli-buster && \
docker push $IMAGE_NAME-pgsql-cli && \
docker push $IMAGE_NAME-pgsql-buster && \
docker push $IMAGE_NAME-pgsql