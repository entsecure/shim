#!/bin/bash
set -e
source VARS
rm -rf toupload output
mkdir -p toupload
echo "Generating base image on which we build our shim RPM"
docker build -t fabricemarie/base:v${SHIM_VERSION} \
    --build-arg FEDORAVER=${FEDORAVER} \
    -f Dockerfile-base . 2>&1 | tee toupload/01-build-base-build-img.log
echo "Uploading base image to docker hub"
docker push fabricemarie/base:v${SHIM_VERSION}
echo "Build and uploaded base build image successfully"
