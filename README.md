
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
