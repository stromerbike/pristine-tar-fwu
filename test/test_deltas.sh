. $(dirname $0)/helper.sh

# test all possible delta formats

DELTABASE="$SAMPLES/deltas/base"

gentar() {
  (cd $DELTABASE && pristine-tar gentar ../$1 $TMPDIR/tarball.out)
}

test_tar_2() {
  gentar tar-2
  assertEquals $? 0
}

test_tar_2_0() {
  gentar tar-2.0
  assertEquals $? 0
}

test_tar_3() {
  gentar tar-3
  assertEquals $? 0
}

test_bz2_2_0() {
  gentar bz2-2.0
  assertEquals $? 0
}

test_gz_2_0() {
  gentar gz-2.0
  assertEquals $? 0
}

test_gz_3_0() {
  gentar gz-3.0
  assertEquals $? 0
}

test_gz_4() {
  gentar gz-4
  assertEquals $? 0
}

test_xz_2_0() {
  gentar xz-2.0
  assertEquals $? 0
}

test_tar_bad() {
  # this is an incorrectly mangled delta; should fail
  gentar tar-bad
  assertNotEquals $? 0
}

. shunit2
