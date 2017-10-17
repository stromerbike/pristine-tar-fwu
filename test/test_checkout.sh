. $(dirname $0)/helper.sh

test_checkout_noop() {
  local orig_tarball=$SAMPLES/tarballs/foo-1.0.tar.gz
  local tarball=$(basename "$orig_tarball")

  git_init pkg
  import_tarball "$orig_tarball"
  silent_run pristine-tar commit "$orig_tarball"

  cp "$orig_tarball" "$tarball"
  touch NOW
  touch --date='1970-01-02 00:00' "$tarball"

  assertSuccess pristine-tar checkout "$tarball"
  assertTrue "$tarball should not be overwritten" "test '$tarball' -ot NOW"
}

test_checkout_signature() {
  local orig_tarball=$SAMPLES/tarballs/foo-1.0.tar.gz
  local upstream_signature=$SAMPLES/signatures/foo-1.0.tar.gz.asc
  local tarball=$(basename "$orig_tarball")
  local signature=$(basename "$upstream_signature")

  git_init pkg
  import_tarball "$orig_tarball"
  silent_run pristine-tar commit -s "${upstream_signature}" "$orig_tarball"

  assertSuccess pristine-tar checkout -s "$signature" "$tarball"
  assertTrue "$signature generated successfully" "cmp '$upstream_signature' '$signature'"
}

. shunit2
