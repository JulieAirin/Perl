package Local::MusicLibrary;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub print_library ($@) {
  my $param = shift;
  my @data = @_;
  my @lib;
  my %temp;
  my %ml = ("band" => 0, "year" => 0, "album" => 0, "track" => 0, "format" => 0); #max length
  for (my $i = 0; $i < scalar @data; $i++) {
    $data[$i] =~ m{^\.\/(.*)\/(\d{4})\s-\s(.*)\/(.*)\.(\w*)$};
    %temp = ("band" => $1, "year" => $2, "album" => $3, "track" => $4, "format" => $5);
    push @lib, {%temp};
    for my $key (keys %temp) {
      if ( length( $temp{$key} ) > $ml{$key} ) {
        $ml{$key} = length( $temp{$key} );
      }
    }
  }

  for my $x (keys %$param) {
    given ($x) {
      #  when ('band','track','album','format','year') {
          #if (%{$param}{$x}) {
          #  @lib = grep {%{$_}{$x} eq %{$param}{$x}} @lib;
          #  $ml{$x} = length($lib[0]{$x});
          #}
      #  }
      #  when ('sort') {
          #if (%{$param}{$x} ne 'year') {
          #  sort {${$lib[$a]}{%{$param}{$x}} cmp {${$lib[$a]}{%{$param}{$x}}} @lib;
          #} else {
          #  sort {${$lib[$a]}{%{$param}{$x}} <=> {${$lib[$a]}{%{$param}{$x}}} @lib;
          #}
      #  }
      #  default {}
    }
  }

  #my $fstr = "-"x"$ml{band}";
  my $str = "| %".$ml{"band"}."s | %".$ml{"year"}."d | %".$ml{"album"}."s | %".$ml{"track"}."s | %".$ml{"format"}."s |\n";
  for (my $i = 0; $i < scalar @lib; $i++) {
    printf $str, $lib[$i]{"band"}, $lib[$i]{"year"}, $lib[$i]{"album"}, $lib[$i]{"track"}, $lib[$i]{"format"};
  }
}

1;
