package Local::MusicLibrary::LibraryFormater;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw/format_library/;

sub format_library ($$) {
  my $param = shift;
  my $libref = shift;
  my $key;

  for my $x (keys %$param) {
    $key = $param->{$x};
    if ($x eq 'sort') {
      if ($key ne 'year') {
        @$libref = sort {$a->{$key} cmp $b->{$key}} @$libref;
      } else {
        @$libref = sort {$a->{$key} <=> $b->{$key}} @$libref;
      }
    } elsif (($x ne 'columns') && ($x ne 'help')) {
      if ($x ne 'year') {
        @$libref = grep {$_->{$x} eq $param->{$x}} @$libref;
      } else {
        @$libref = grep {$_->{$x} == $param->{$x}} @$libref;
      }
    } elsif ($x eq 'columns') {
      if ($key eq '') {
        exit;
      }
    }
  }
}
