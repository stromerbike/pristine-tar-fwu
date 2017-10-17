get_size() {
  stat --format=%s "$1"
}

try_with_and_without_recompress() {
  tarball="$1"
  name="$(basename "$tarball")"
  cp $SAMPLES/$tarball .
  silent_run pristine-tar gendelta $name regular.delta
  silent_run pristine-tar --recompress gendelta $name compressed.delta
  regular_delta_size=$(get_size regular.delta)
  compressed_delta_size=$(get_size compressed.delta)
}

