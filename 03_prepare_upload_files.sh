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
REST="attestation Dockerfile-base Dockerfile-build evren_securebootca_cert.der "
REST+="reproduce_build.sh sbat.evren.csv shim-find-debuginfo.sh shim.patches shim-unsigned-x64.spec "
REST+="shim-unsigned-x64.spec.fedora-orig entsecureca_trust_chain.pem VARS verify_attestation.patch "
REST+="do_review.sh evren_secureboot_signer_cert.der signer2_trust_chain.pem attestation2 patches "
REST+="evren_dbx.esl update_vendor_dbx.sh"
for TO_CP in $REST; do
    /usr/bin/cp -fr ${TO_CP} toupload/
done
/usr/bin/cp -fr Dockerfile-reproduce toupload/Dockerfile
/usr/bin/cp -ar revoked-certs toupload/

sed "s#@@SHIM_VERSION@@#${SHIM_VERSION}#g" -i toupload/Dockerfile
sed "s#@@SHIM_ARCHIVE_URL@@#${SHIM_ARCHIVE_URL}#g" -i toupload/Dockerfile
sed "s#@@SHIM_ARCHIVE_FILE@@#${SHIM_ARCHIVE_FILE}#g" -i toupload/Dockerfile
sed "s#@@SHIM_ARCHIVE_SHA256@@#${SHIM_ARCHIVE_SHA256}#g" -i toupload/Dockerfile
sed "s#@@VERIFY_ATTESTATION_SCRIPT_URL@@#${VERIFY_ATTESTATION_SCRIPT_URL}#g" -i toupload/Dockerfile
sed "s#@@PARSE_VERIFIED_ATTESTATION_SCRIPT_URL@@#${PARSE_VERIFIED_ATTESTATION_SCRIPT_URL}#g" -i toupload/Dockerfile

find toupload -type d -exec chmod 755 {} \;
find toupload -type f -exec chmod 644 {} \;
chmod 755 toupload/reproduce_build.sh toupload/shim-find-debuginfo.sh
