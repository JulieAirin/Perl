package Local::MusicLibrary;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw/check_params/;

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub check_params ($) {
  my $param = shift;
  my @cols = [];
  if ($param->{columns}) {
    @cols = split (/\,/, $param->{columns});
    for my $x (@cols) {
      return 0 unless ($x=~/^(band|album|year|track|format)$/);
    }
  }
  return 1;
}

1;
