package Local::Row::Simple;

use strict;
use warnings;
use Moose;
use DDP;

=encoding utf8

=head1 NAME

Local::Row::Simple - каждая строка — набор пар `ключ:значение`, соединенных запятой.
В ключах и значениях не может быть двоеточий и запятых.

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
    my @temp;
    for my $x (split ',', $self->str) {
      @temp = split ':', $x;
      ${$self->elements}{ $temp[0] } = $temp[1];
    }
}

=head1 SYNOPSIS

=cut

1;
