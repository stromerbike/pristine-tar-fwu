. $(dirname $0)/helper.sh
. $(dirname $0)/recompress_helper.sh

if [ ! -d $SAMPLES/regression-test-suite ]; then
  echo "W: skipping tests that need the regression test suite"
  exit
fi

tarballs="regression-test-suite/knownproblems"

test_recompress_should_fix_broken_tarballs() {
  try_with_and_without_recompress "$tarballs/nsis_2.46.orig.tar.bz2"
  assertTrue 'test -f compressed.delta'
}

test_recompress_does_not_increase_delta_size() {
  # TODO find a tarball that is small enough and reproduces the issue
  :
}

. shunit2
