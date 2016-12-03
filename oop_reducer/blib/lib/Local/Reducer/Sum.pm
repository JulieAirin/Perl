package Local::Reducer::Sum;

use strict;
use warnings;
use Moose;
use DDP;

extends 'Local::Reducer';

=encoding utf8

=head1 NAME

Local::Reducer::Sum - суммирует значение поля, указанного в параметре `field`
конструктора, каждой строки лога.

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

has 'field' => (is => 'ro');

sub reduce_n ($$) {
  my ($self, $n) = @_;
  my $str;
  my $row;

  $self->{reduced} = $self->{initial_value};
  $self->source->reset_index();

  for (my $i = 1; $i <= $n; $i++) {
    $str = $self->source->next();
    if ($str ne 'undef') {
      $row = $self->row_class->new('str' => $str);
      $self->{reduced} += $row->get($self->field,0);
    }
  }

  return $self->{reduced};
}

sub reduce_all {
  my ($self) = @_;
  $self->source->reset_index();
  my $str = $self->source->next();
  my $row;

  $self->{reduced} = $self->{initial_value};

  while ($str ne 'undef') {
    $row = $self->row_class->new('str' => $str);
    $self->{reduced} += $row->get($self->field,0);
    $str = $self->source->next();
  }

  return $self->{reduced};
}

=head1 SYNOPSIS

=cut

1;
