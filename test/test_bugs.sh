. $(dirname $0)/helper.sh

test_700448() {
  # pristine-tar list should work with empty repo
  git_init pkg
  assertSuccess pristine-tar list
}

test_798641() {
  git_init r1; local r1=$REPODIR
  git_init r2; local r2=$REPODIR
  git_init r3; local r3=$REPODIR
  local tarball="$SAMPLES/tarballs/foo-1.0.tar.bz2"

  cd $r1
  import_tarball "$tarball"
  silent_run pristine-tar commit "$tarball"
  silent_run git remote add r2 $r2
  silent_run git push r2 pristine-tar
  silent_run git remote add r3 $r3
  silent_run git push r3 pristine-tar
  silent_run git branch -m pristine-tar tmp-branch

  assertSuccess pristine-tar list
  assertSuccess pristine-tar checkout "$(basename $tarball)"
  assertFailure pristine-tar commit "$tarball"

  git branch -m tmp-branch pristine-tar
  silent_run pristine-tar commit "$tarball"
  silent_run git push r3 pristine-tar
  silent_run git branch -D pristine-tar

  assertFailure pristine-tar list
  assertFailure pristine-tar checkout "$(basename $tarball)"
  assertFailure pristine-tar commit "$tarball"
}

test_851286() {
  # tarballs with files starting with "-" should work
  local orig_tarball="$SAMPLES/tarballs/libinotify-kqueue_20120419.orig.tar.xz"
  
  git_init pkg
  import_tarball "$orig_tarball"
  silent_run pristine-tar commit "$orig_tarball"
}

. shunit2
