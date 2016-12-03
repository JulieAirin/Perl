package Local::Source::Array;

use strict;
use warnings;
use Moose;
use DDP;

extends 'Local::Source';

=encoding utf8

=head1 NAME

Local::Source::Array - отдает поэлементно массив

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

has 'array' => (is => 'ro');

sub next {
  my ($self) = @_;
  if ( $self->{cur_index} < scalar @{$self->array}-1 ) {
    $self->{cur_index} += 1;
    return ${$self->array}[$self->cur_index];
  } else {
    return 'undef';
  }
}

=head1 SYNOPSIS

=cut

1;
