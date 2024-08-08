
# UEFI Shim

Evren rebuild of Fedora 39's shim:
- using Evren rootCA instead of Fedora's
- adding Evren's sbat values
- NX compat support present but turned off (like Fedora)

No additional/original patch are applied beyond that

# Build output

The directory `output` contains the built unsigned-shim as RPMs
and extracted into individual files.

# Shim review folder

A shim review supporting data folder is created automatically
over in the `toupload` directory. It includes all the requested
support files including all the logs.

# Revocation notes

The original boot signer cert has been revoked as we signed memtest86+ efi
before it was fully ready.

So the certificate `C=SG, O=Entsecure South East Asia Pte Ltd, OU=Evren, CN=Evren Boot Signer 1`
has been added to our `VENDOR_DBX_FILE`. The original certificate can be found
in `revoked-certs/`.
