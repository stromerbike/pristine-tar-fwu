# pristine-tar-fwu
A fork of https://joeyh.name/code/pristine-tar adapoted for performing delta updates in embedded systems.

## Changes made
* Running pristine-tar's gendelta or gentar has been made more robust by only considering entries mentioned in the manifest file. This is especially useful when generating a tarball from an active system partition.
