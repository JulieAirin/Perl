package Local::Reducer;

use strict;
use warnings;
use Moose;
use DDP;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

has 'source' => (is => 'ro');
has 'row_class' => (is => 'ro');
has 'initial_value' => (is => 'ro');
has 'reduced' => (is => 'rw');

sub reduce_n ($$) {

}

sub reduce_all {

}

=head1 SYNOPSIS

=cut

1;
