package Local::Reducer::MaxDiff;

use strict;
use warnings;
use Moose;
use DDP;

extends 'Local::Reducer';

=encoding utf8

=head1 NAME

Local::Reducer::MaxDiff - выясняет максимальную разницу между полями,
указанными в параметрах `top` и `bottom` конструктора, среди всех строк лога.

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

has 'top' => (is => 'ro');
has 'bottom' => (is => 'ro');

sub reduce_n ($$) {
  my ($self, $n) = @_;
  my $row;
  my $str;
  my $top;
  my $bottom;
  my $max = $self->{initial_value};
  $self->source->reset_index();

  for (my $i = 1; $i <= $n; $i++) {
    $str = $self->source->next();
    if ($str ne 'undef') {
      $row = $self->row_class->new('str' => $str);
      $top = $row->get($self->top,0);
      $bottom = $row->get($self->bottom,0);
      if ( abs($top-$bottom) > $max ) {
        $max = abs($top-$bottom);
      }
    }
  }

  $self->{reduced} = $max;
  return $self->{reduced};
}

sub reduce_all {
  my ($self) = @_;
  $self->source->reset_index();
  my $str = $self->source->next();
  my $row;
  my $top;
  my $bottom;
  my $max = $self->{initial_value};

  while ($str ne 'undef') {
    $row = $self->row_class->new('str' => $str);
    $top = $row->get($self->top,0);
    $bottom = $row->get($self->bottom,0);
    if ( abs($top-$bottom) > $max ) {
      $max = abs($top-$bottom);
    }
    $str = $self->source->next();
  }

  $self->{reduced} = $max;
  return $self->{reduced};
}

=head1 SYNOPSIS

=cut

1;
