#!/bin/bash
set -e
source VARS
rm -rf toupload output
mkdir -p toupload
echo "Generating base image on which we build our shim RPM"
docker build -t evren/shim-img:v${SHIM_VERSION} \
    --build-arg FEDORAVER=${FEDORAVER} \
    -f Dockerfile-base . 2>&1 | tee toupload/01-build-base-build-img.log
echo "Saving the base image as a portable tar file to help with build reproduction"
rm -f docker-shim-img-v${SHIM_VERSION}.tar docker-shim-img-v${SHIM_VERSION}.tar.bz2
docker save evren/shim-img:v${SHIM_VERSION} | bzip2 > docker-shim-img-v${SHIM_VERSION}.tar.bz2
sha256sum docker-shim-img-v${SHIM_VERSION}.tar.bz2 > docker-shim-img-v${SHIM_VERSION}.tar.bz2.shasum256
echo "Saving the base image to the cloud"
aws s3 cp docker-shim-img-v${SHIM_VERSION}.tar.bz2 s3://support-files.evren.co/shim/
echo "Invalidating the CDN cache"
aws cloudfront create-invalidation \
    --distribution-id EA33PNILVDLR7 \
    --paths '/shim*'
rm -f docker-shim-img-v${SHIM_VERSION}.tar.bz2
echo "Build base build image successfully"
