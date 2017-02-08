# pristine-tar-fwu
A fork of https://joeyh.name/code/pristine-tar adapted for performing over the air delta updates in embedded systems where bandwidth is sparse.

## Goals
* Recreation of tarballs from an entire, preferably read-only, active system partition (incl. root file system and additionally kernel).
* Reduction of used bandwidth for downloading updates.
* Usage of commands included in BusyBox where possible.

## Changes made to pristine-tar
* The commands gendelta or gentar have been made more robust by only considering entries mentioned in the manifest file. This is especially useful when generating a tarball from an active system partition.
* The command gendelta has been changed to use LZMA (with compression level 9) for the generation of delta files.

## Remarks
* The components pristine-bz2, pristine-gz and pristine-xz have not been adapted. 
