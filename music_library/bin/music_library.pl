#!/usr/bin/env perl

use strict;
use warnings;
use Local::MusicLibrary;
use Getopt::Long;

my $param = {};
GetOptions($param, 'band=s', 'year=i', 'track=s', 'album=s', 'format=s', 'sort=s', 'columns=s');


my @library;
while (<>) {
  push @library, $_;
}

Local::MusicLibrary::print_library($param,@library);
