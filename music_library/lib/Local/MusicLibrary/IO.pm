package Local::MusicLibrary::IO;

use strict;
use warnings;
use Local::MusicLibrary::Processor qw/process_keys/;
use Exporter 'import';

our @EXPORT = qw/get_library print_library/;

sub get_library ($@) {
  my $param = shift;
  my @data = @_;
  my @lib;
  for (@data) {
    chomp $_;
    $_ =~ m{
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
  return \@lib;
}

sub print_library ($$) {
  my $param = shift;
  my $libref = shift;
  my @cols = ('band', 'year', 'album', 'track', 'format');
  my %ml = ("band" => 0, "year" => 0, "album" => 0, "track" => 0, "format" => 0);

  if (scalar @$libref == 0) {
    return 1;
  }

  for (@$libref) {
    for my $key (@cols) {
      if ( $ml{$key} < length ($_->{$key}) ) {
        $ml{$key} = length ($_->{$key});
      }
    }
  }
  if ($param->{columns}) {
    @cols = split /,/, $param->{columns};
  }

  my $str = ''; #строка с песней
  my @list = ();
  my $len = -1;

  for my $key (@cols) {
    $len += $ml{$key} + 3;
    push @list, "-"x"$ml{$key}"."--";
  }
  my $fstr = "/"."-"x"$len"."\\\n"; #первая строка
  my $lstr = "\\"."-"x"$len"."/\n"; #последняя строка
  my $bstr = "|".( join "+", @list )."|\n"; #разделитель

  print $fstr;
  for (@$libref) {
    print $bstr if (${$libref}[0] != $_);
    $str = "|";
    @list = ();
    for my $key (@cols) {
      $str = $str." %".$ml{$key}."s |";
      push @list, $_->{$key};
    }
    printf $str."\n", @list;
  }
  print $lstr;
}
