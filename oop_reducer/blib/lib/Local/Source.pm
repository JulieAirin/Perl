package Local::Source;

use strict;
use warnings;
use Moose;
use DDP;

=encoding utf8

=head1 NAME

Local::Source - базовый абстрактный класс

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

has 'cur_index' => (is => 'rw');

sub reset_index {
  my ($self) = @_;
  $self->{cur_index} = -1;
}

=head1 SYNOPSIS

=cut

1;
