. $(dirname $0)/helper.sh

test_checkout_noop() {
  local orig_tarball=$SAMPLES/tarballs/foo-1.0.tar.gz
  local tarball=$(basename "$orig_tarball")

  git_init pkg
  import_tarball "$orig_tarball"
  pristine-tar commit "$orig_tarball"

  cp "$orig_tarball" "$tarball"
  touch NOW
  touch --date='1970-01-02 00:00' "$tarball"

  assertSuccess pristine-tar checkout "$tarball"
  assertTrue "$tarball should not be overwritten" "test '$tarball' -ot NOW"
}

. shunit2
