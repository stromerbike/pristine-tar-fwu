#!/usr/bin/perl
# Wrappers around delta computing programs
# the following naming is used:
#  - try_* : tries to run the command
#            and returns the return code
#  - do_*  : runs the command and fails if it failed

package Pristine::Tar::DeltaTools;

use Pristine::Tar;
use warnings;
use strict;

use Exporter q{import};
our @EXPORT = qw(try_xdelta_patch do_xdelta_patch try_xdelta_diff do_xdelta_diff
  try_xdelta3_patch do_xdelta3_patch try_xdelta3_diff do_xdelta3_diff);

#
# xdelta
#

sub try_xdelta_patch {
  my ($fromfile, $diff, $tofile) = @_;
  return try_doit("xdelta", "patch", "--pristine", $diff, $fromfile, $tofile)
    >> 8;
}

sub do_xdelta_patch {
  die "xdelta patch failed!" if (try_xdelta_patch(@_) != 0);
}

sub try_xdelta_diff {
  my ($fromfile, $tofile, $diff) = @_;
  my $ret =
    try_doit("xdelta", "delta", "-0", "--pristine", $fromfile, $tofile, $diff)
    >> 8;
  # xdelta delta returns either 0 or 1 on success
  return ($ret == 1 || $ret == 0) ? 0 : $ret;
}

sub do_xdelta_diff {
  die "xdelta delta failed!" if (try_xdelta_diff(@_) != 0);
}

#
# xdelta3
#

sub try_xdelta3_patch {
  my ($fromfile, $diff, $tofile) = @_;
  return try_doit("xdelta3", "decode", "-f", "-D", "-s",
    $fromfile, $diff, $tofile) >> 8;
}

sub do_xdelta3_patch {
  die "xdelta3 decode failed!" if (try_xdelta3_patch(@_) != 0);
}

sub try_xdelta3_diff {
  my ($fromfile, $tofile, $diff) = @_;
  return try_doit("xdelta3", "encode", "-0", "-f", "-D", "-s",
    $fromfile, $tofile, $diff) >> 8;
}

sub do_xdelta3_diff {
  die "xdelta3 encode failed!" if (try_xdelta3_diff(@_) != 0);
}

1;
