. $(dirname $0)/helper.sh
. $(dirname $0)/recompress_helper.sh

test_recompress_reduces_delta_size() {
  try_with_and_without_recompress 'tarballs/plasmidomics_0.2.0.orig.tar.gz'
  assertTrue 'compressed < regular' "[ $compressed_delta_size -lt $regular_delta_size ]"
}

. shunit2
