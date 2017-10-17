# Tests for backwards-compatibility with data produced by pristine-tar 1.33

. $(dirname $0)/helper.sh

assertReproduces() {
  local compression="$1"
  tar xaf $SAMPLES/1.33/foo.tar.${compression}
  cd foo-${compression}
  silent_run pristine-tar checkout foo-1.0.tar.${compression}
  assertHashEquals foo-1.0.tar.${compression} $SAMPLES/tarballs/foo-1.0.tar.${compression}
}

test_bz2() {
  assertReproduces bz2
}

test_gz() {
  assertReproduces gz
}

test_xz() {
  assertReproduces xz
}

. shunit2
