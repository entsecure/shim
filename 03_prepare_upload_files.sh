#!/bin/bash
source VARS
set -e
pushd output/RPMS/x86_64/
for i in *.rpm; do
rpm2cpio ${i} | cpio -idmv
done
cp ./usr/share/shim/${SHIM_VERSION}*/ia32/shimia32.efi ../../../toupload/
cp ./usr/share/shim/${SHIM_VERSION}*/x64//shimx64.efi ../../../toupload/
popd
REST="attestation Dockerfile-base Dockerfile-build Dockerfile-reproduce evren_securebootca_cert.der "
REST+="reproduce_build.sh sbat.evren.csv shim-find-debuginfo.sh shim.patches shim-unsigned-x64.spec "
REST+="shim-unsigned-x64.spec.fedora-orig entsecureca_trust_chain.pem VARS verify_attestation.patch "
REST+="do_review.sh evren_secureboot_signer_cert.der signer1_trust_chain.pem attestation2 patches"
for TO_CP in $REST; do
    /usr/bin/cp -fr ${TO_CP} toupload/
done
NEW=`cat docker-shim-img-v${SHIM_VERSION}.tar.bz2.shasum256`
rm -f docker-shim-img-v${SHIM_VERSION}.tar.bz2.shasum256
cat reproduce_build.sh | sed "s/@@REPLACEME@@/${NEW}/g" > toupload/reproduce_build.sh
find -type d -exec chmod 755 {} \;
find -type f -exec chmod 644 {} \;
chmod 755 toupload/reproduce_build.sh toupload/shim-find-debuginfo.sh
