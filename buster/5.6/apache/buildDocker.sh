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
--tag $IMAGE_NAME-${variant}-buster \
--tag $IMAGE_NAME-${variant} \
--tag rodrixcornell/php:${variant}-buster \
--tag rodrixcornell/php:${variant} \
--file Dockerfile .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-mysql-${variant}-buster \
--tag $IMAGE_NAME-mysql-${variant} \
--tag rodrixcornell/php:mysql-${variant}-buster \
--tag rodrixcornell/php:mysql-${variant} \
--file Dockerfile.mysql .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-oci-${variant}-buster \
--tag $IMAGE_NAME-oci-${variant} \
--tag rodrixcornell/php:oci-${variant}-buster \
--tag rodrixcornell/php:oci-${variant} \
--file Dockerfile.oracle .

docker build --force-rm --no-cache $IMAGE_BUILD $PROXY_SETTINGS \
--tag $IMAGE_NAME-pgsql-${variant}-buster \
--tag $IMAGE_NAME-pgsql-${variant} \
--tag rodrixcornell/php:pgsql-${variant}-buster \
--tag rodrixcornell/php:pgsql-${variant} \
--file Dockerfile.pgsql .

docker push $IMAGE_NAME-${variant}-buster && \
docker push $IMAGE_NAME-${variant} && \
docker push rodrixcornell/php:${variant}-buster && \
docker push rodrixcornell/php:${variant}

docker push $IMAGE_NAME-mysql-${variant}-buster && \
docker push $IMAGE_NAME-mysql-${variant}
docker push rodrixcornell/php:mysql-${variant}-buster && \
docker push rodrixcornell/php:mysql-${variant}

docker push $IMAGE_NAME-oci-${variant}-buster && \
docker push $IMAGE_NAME-oci-${variant}
docker push rodrixcornell/php:oci-${variant}-buster && \
docker push rodrixcornell/php:oci-${variant}

docker push $IMAGE_NAME-pgsql-${variant}-buster && \
docker push $IMAGE_NAME-pgsql-${variant}
docker push rodrixcornell/php:pgsql-${variant}-buster && \
docker push rodrixcornell/php:pgsql-${variant}