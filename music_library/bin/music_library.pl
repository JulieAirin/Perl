#!/usr/bin/env perl

use strict;
use warnings;
use Local::MusicLibrary qw/check_params/;
use Local::MusicLibrary::LibraryPrinter qw/form_library/;
use Getopt::Long;
use Pod::Usage;
use DDP;

my $param = {};
GetOptions($param, 'band=s', 'year=i', 'track=s', 'album=s', 'format=s', 'sort=s', 'columns=s', 'help')
  or pod2usage();

pod2usage unless (check_params($param));
pod2usage if ($param->{help});

my @library;
while (<>) {
  push @library, $_;
}

form_library($param,@library);

=head1 SYNOPSIS

Использование параметров:

--band BAND
  Оставить только композиции группы BAND

--year YEAR
  Оставить только композиции с альбомов года YEAR

--album ALBUM
  Оставить только композиции с альбомов с именем ALBUM

--track TRACK
  Оставить только композиции с именем TRACK

--format FORMAT
  Оставить только композиции в формате FORMAT

--sort FIELD
  Сортировать по возрастанию значения указанного параметра.
  FIELD  может принимать band, year, album, track и format

--columns COL_1,...,COL_N
  Список колонок через запятую, которые должны появиться в таблице (с учетом порядка).
  COL_I  может принимать значения band, year, album, track и format.
  Дублирование значения допускается.

=cut
