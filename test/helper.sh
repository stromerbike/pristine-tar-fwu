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
  git init
  git config user.name 'Test User'
  git config user.email 'test@example.com'
  REPODIR="$TMPDIR/$repo"
}

import_tarball() {
  local tarball="$1"
  tar --strip-components=1 -xaf "$tarball"
  git add .
  git commit -m 'Initial commit'
  git branch upstream
}

assertHashEquals() {
  $COMPARE "$1" "$2"
  sha1_1=$(get_sha1 "$1")
  sha1_2=$(get_sha1 "$2")
  assertEquals "$sha1_1" "$sha1_2"
}

assertSuccess() {
  (>&2 echo "I: assertSuccess($@)")
  "$@"
  rc=$?
  assertEquals 0 "$rc"
}

assertFailure() {
  (>&2 echo "I: assertFailure($@)")
  "$@"
  rc=$?
  assertNotEquals 0 "$rc"
}
