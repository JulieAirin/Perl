package Local::MusicLibrary::LibraryFormater;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw/format_library print_library/;

sub format_library ($$) {
  my $param = shift;
  my $libref = shift;
  my $key;

  for my $x (keys %$param) {
    $key = ${$param}{$x};
    if ($x eq 'sort') {
      if ($key ne 'year') {
        @$libref = sort {$a->{$key} cmp $b->{$key}} @$libref;
      } else {
        @$libref = sort {$a->{$key} <=> $b->{$key}} @$libref;
      }
    } elsif (($x ne 'columns') && ($x ne 'help')) {
      if (${$param}{$x}) {
        @$libref = grep {%{$_}{$x} eq %{$param}{$x}} @$libref;
      }
    }
  }
}

sub print_library ($$) {
  my $param = shift;
  my $libref = shift;
  my @cols = ('band', 'year', 'album', 'track', 'format');
  my %ml = ("band" => 0, "year" => 0, "album" => 0, "track" => 0, "format" => 0);
  my $i;

  for ($i = 0, $i < scalar @$libref, $i++) {
    for my $key (@cols) {
      if ( $ml{$key} < length (${$libref}[$i]->{$key}) ) {
        $ml{$key} = length (${$libref}[$i]->{$key});
      }
    }
  }
  if (${$param}{columns}) {
    @cols = split /,/, ${$param}{columns};
  }

  my $fstr = '/'; #первая строка
  my $lstr = '\\'; #последняя строка
  my $bstr = '|'; #разделитель
  my $str = ''; #строка с песней
  my @list = [];

  for my $key (@cols) {
    $fstr = $fstr."-"x"$ml{$key}"."---";
    $lstr = $lstr."-"x"$ml{$key}"."---";
    $bstr = $bstr."-"x"$ml{$key}"."--+";
  }
  $fstr = ($fstr)."\\\n";
  $lstr = ($lstr)."/\n";
  $bstr = ($bstr)."|\n";
  print $fstr, $bstr, $lstr;
  for ($i = 0, $i < scalar @$libref, $i++) {
    for my $key (@cols) {

    }
  }

  print %ml;
}
