#!/bin/bash
set -e
source VARS
mkdir -p output

echo "Building shim" | tee toupload/02-shim-build.log
docker build -t evren/shim-build:v${SHIM_VERSION} -f Dockerfile-build \
    --build-arg SHIM_VERSION=${SHIM_VERSION} \
    --build-arg SHIM_ARCHIVE_URL=${SHIM_ARCHIVE_URL} \
    --build-arg SHIM_ARCHIVE_FILE=${SHIM_ARCHIVE_FILE} \
    --build-arg SHIM_ARCHIVE_SHA256=${SHIM_ARCHIVE_SHA256} \
    . 2>&1 | tee -a toupload/02-shim-build.log

echo -e "\nCopying generating shim RPM to output directory\n" | tee -a toupload/02-shim-build.log

docker run --rm \
    --volume=`pwd`/output:/output:rw \
    evren/shim-build:v${SHIM_VERSION} 2>&1 | tee -a toupload/02-shim-build.log
echo "Successfully generated shim and copied it to output directory"
