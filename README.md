# pristine-tar-fwu
A fork of https://joeyh.name/code/pristine-tar adapted for performing over the air delta updates in a Yocto based embedded systems where bandwidth is sparse.

## Goals
* Recreation of tarballs from an active system partition (incl. root file system and additionally kernel).
* Reduction of used bandwidth for downloading updates.
* Usage of commands included in BusyBox where possible.
* Modification of original pristine-tar source only where necessary in order to facilitate updating to newer pristine-tar versions.

## Changes made to pristine-tar
* The commands gendelta and gentar have been made more robust by only considering entries mentioned in the manifest file. This is useful when generating a tarball from an active system partition where hardware devices are mounted as files such as /sys/class/tty or /dev/tty.
* The command gendelta has been changed to use LZMA (with compression level 9) for the generation of delta files to decrease their size.
* The command validate has been added to validate an existing tarball using the specified delta file.
* All files in the recreated tarball have mode 0755 to match the original Yocto tarball as closely as possible and thus reducing the size of the delta.
* The TMPDIR for source and tar files can optionally be set via TMPDIR_SRC and TMPDIR_TAR.

## Remarks
* The components pristine-bz2, pristine-gz and pristine-xz have not been adapted and should not be used for updates.
