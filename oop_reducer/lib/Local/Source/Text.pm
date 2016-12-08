package Local::Source::Text;

use strict;
use warnings;
use Moose;
use DDP;

extends 'Local::Source';

=encoding utf8

=head1 NAME

Local::Source::Text - отдает построчно текст

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

has 'text' => (is => 'ro');
has 'delimiter' => (is => 'ro', default => '\n');
has 'rows' => (is => 'rw', default => sub {[]});

sub next {
  my ($self) = @_;
  if ( $self->{cur_index} < scalar @{$self->rows}-1 ) {
    $self->{cur_index} += 1;
    return ${$self->rows}[$self->cur_index];
  } else {
    return undef;
  }
}

sub BUILD {
  my ($self) = @_;
  @{$self->rows} = split $self->delimiter, $self->text;
}

=head1 SYNOPSIS

=cut

1;
