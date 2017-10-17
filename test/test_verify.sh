. $(dirname $0)/helper.sh

test_verify_intact_tarball() {
  local orig_tarball=$SAMPLES/tarballs/foo-1.0.tar.gz
  local tarball=$(basename "$orig_tarball")

  git_init pkg
  import_tarball "$orig_tarball"
  silent_run pristine-tar commit "$orig_tarball"

  assertSuccess pristine-tar verify "$orig_tarball"
}

test_verify_corrupt_tarball() {
  local orig_tarball=$SAMPLES/tarballs/foo-1.0.tar.gz
  local tarball=$(basename "$orig_tarball")

  git_init pkg
  import_tarball "$orig_tarball"
  silent_run pristine-tar commit "$orig_tarball"

  date > "$tarball" # "corrupted" tarball
  assertFailure pristine-tar verify "$tarball"
}

test_verify_without_stored_hash() {
  # the deltas created by pristine-tar 1.33 don't have a hash stored.
  # Nevertheless, pristine-tar should still be able to verify an existing
  # tarball.
  tar xaf "$SAMPLES/1.33/foo.tar.gz"
  cd foo-gz
  tarball='foo-1.0.tar.gz'
  silent_run pristine-tar checkout "$tarball"

  assertSuccess pristine-tar verify "$tarball"
}

test_verify_fails_without_stored_hash() {
  # the deltas created by pristine-tar 1.33 don't have a hash stored.
  # Nevertheless, pristine-tar should still be able to verify an existing
  # tarball.
  tar xaf "$SAMPLES/1.33/foo.tar.gz"
  cd foo-gz
  tarball='foo-1.0.tar.gz'
  touch "$tarball" # "corrupted"

  assertFailure pristine-tar verify "$tarball"
}

. shunit2
