#!/bin/bash
set -e
source VARS
mkdir -p output
podman build -t evren/shim-build:v${SHIM_VERSION} -f Containerfile-build \
    --build-arg SHIM_VERSION=${SHIM_VERSION} \
    --env SHIM_ARCHIVE_URL=${SHIM_ARCHIVE_URL} \
    --env SHIM_ARCHIVE_FILE=${SHIM_ARCHIVE_FILE} \
    --env SHIM_ARCHIVE_SHA256=${SHIM_ARCHIVE_SHA256} \
    --volume=`pwd`/output:/output:rw 2>&1 | tee toupload/02-shim-build.log
echo "Successfully generated shim"
