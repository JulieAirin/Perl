package Local::MusicLibrary;

use strict;
use warnings;
use Local::MusicLibrary::LibraryFormater qw/format_library print_library/;
use Exporter 'import';

our @EXPORT = qw/form_library check_params/;

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
  if (${$param}{columns}) {
    @cols = split (/\,/, ${$param}{columns});
    for my $x (@cols) {
      if (($x ne 'band') && ($x ne 'album') && ($x ne 'year') && ($x ne 'track') && ($x ne 'format')) {
        return 0;
      }
    }
  }
  return 1;
}

sub form_library ($@) {
  my $param = shift;
  my @data = @_;
  my @lib;
  for (my $i = 0; $i < scalar @data; $i++) {
    $data[$i] =~ m{
      ^
        \. /
        (?<band>[^/]+)
        /
        (?<year>\d+)
        \s+ - \s+
        (?<album>[^/]+)
        /
        (?<track>.+)
        \.
        (?<format>[^\.]+)
      $
    }x;
    push @lib, { band => $+{band}, year => $+{year}, album => $+{album}, track => $+{track}, format => $+{format} };
  }
  #ПРОВЕРКА ВХОДНЫХ ДАННЫХ!
  format_library ($param,\@lib);
  print_library ($param,\@lib);
  #my $fstr = "-"x"$ml{band}";
  #my $str = "| %".$ml{"band"}."s | %".$ml{"year"}."d | %".$ml{"album"}."s | %".$ml{"track"}."s | %".$ml{"format"}."s |\n";
  #for (my $i = 0; $i < scalar @lib; $i++) {
  #  print $lib[$i]{"band"}, $lib[$i]{"year"}, $lib[$i]{"album"}, $lib[$i]{"track"}, $lib[$i]{"format"};
  #}
}

1;
