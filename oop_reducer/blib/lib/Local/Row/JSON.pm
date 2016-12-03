package Local::Row::JSON;

use strict;
use warnings;
use Moose;
use DDP;
use JSON::XS;

=encoding utf8

=head1 NAME

Local::Row::JSON - каждая строка — JSON

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

has 'str' => (is => 'ro');
has 'elements' => (is => 'rw', default => sub {{}});

sub get {
  my ($self, $name, $default) = @_;
  if ( ${ $self->elements }{$name} ) {
    return ${ $self->elements }{$name};
  } else {
    return $default;
  }
}

sub BUILD {
    my ($self) = @_;
    %{$self->elements} = %{JSON::XS->new->utf8->decode($self->str)};
}

=head1 SYNOPSIS

=cut

1;
