CURDIR=$(pwd)
SAMPLES=$(readlink -f $(dirname $0))/samples
SRCDIR=$(readlink -f $(dirname $0)/..)

if which diffoscope > /dev/null; then
  COMPARE=diffoscope
else
  COMPARE=true
  echo "I: install diffoscope to compare files beyond their hash"
fi

if [ -z "$ADTTMP" ]; then
  export PATH="$SRCDIR/blib/script":"$SRCDIR/zgz":"$PATH"
  export PERL5LIB="$SRCDIR/blib/lib"
  (
    set -e
    if [ ! -f Makefile ]; then
      perl Makefile.PL
    fi
    make -s
  )
fi


setUp() {
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
}

tearDown() {
  cd "$CURDIR"
  rm -rf "$TMPDIR"
}

get_sha1() {
  sha1sum "$@" | awk '{print($1)}'
}

git_init() {
  local repo="$1"
  cd "$TMPDIR"
  mkdir "$repo"
  cd "$repo"
  silent_run git init
  silent_run git config user.name 'Test User'
  silent_run git config user.email 'test@example.com'
  REPODIR="$TMPDIR/$repo"
}

import_tarball() {
  local tarball="$1"
  tar --strip-components=1 -xaf "$tarball"
  silent_run git add .
  silent_run git commit -m 'Initial commit'
  silent_run git branch upstream
}

assertHashEquals() {
  silent_run $COMPARE "$1" "$2"
  sha1_1=$(get_sha1 "$1")
  sha1_2=$(get_sha1 "$2")
  assertEquals "$sha1_1" "$sha1_2"
}

assertSuccess() {
  silent_run "$@"
  rc=$?
  assertEquals 0 "$rc"
}

assertFailure() {
  silent_run "$@"
  rc=$?
  assertNotEquals 0 "$rc"
}

silent_run() {
  local rc
  rc=0
  "$@" > log 2>&1 || rc=$?
  if [ "$rc" -ne 0 ]; then
    cat log
  fi
  rm -f log
  return "$rc"
}
