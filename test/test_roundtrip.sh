. $(dirname $0)/helper.sh

assertWorksWithTarball() {
  local orig_tarball="$1"
  local tarball=$(basename "$orig_tarball")
  local dir=$(echo "$tarball" | cut -d - -f 1)

  git_init "$dir"

  import_tarball "$orig_tarball"

  pristine-tar commit "$orig_tarball"
  pristine-tar checkout "$tarball"

  assertHashEquals "$orig_tarball" "$tarball"
}

test_bz2() {
  assertWorksWithTarball $SAMPLES/tarballs/foo-1.0.tar.bz2
}

test_gz() {
  assertWorksWithTarball $SAMPLES/tarballs/foo-1.0.tar.gz
}

test_xz() {
  assertWorksWithTarball $SAMPLES/tarballs/foo-1.0.tar.xz
}

test_gz_xdelta3() {
  # test roundtrip with xdelta3 program
  PRISTINE_ALL_XDELTA=xdelta3 assertWorksWithTarball $SAMPLES/tarballs/foo-1.0.tar.gz
  # check whether really xdelta3 is used here
  git checkout pristine-tar
  tar -xOf foo-1.0.tar.gz.delta version > version
  # check pristine-tar delta version
  assertSuccess grep 3 version
  tar -xOf foo-1.0.tar.gz.delta wrapper > wrapper.tar.gz
  tar -xOf wrapper.tar.gz version > version
  # check pristine-gz delta version
  assertSuccess grep 4 version
  tar -xOf wrapper.tar.gz delta > delta
  assertSuccess xdelta3 printdelta delta >/dev/null
}

. shunit2
