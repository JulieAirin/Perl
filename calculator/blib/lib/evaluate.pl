=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub evaluate {
	my $rpn = shift;
	my @res;
	my $temp1 = 0;
	my $temp2 = 0;

	for my $x (@$rpn) {
		given ($x) {
			when (/\d/) {
				push @res, $x;
			}
			when ('U+'){} #унарный плюс ничего не делает с числами
			when ('U-'){
				$temp1 = pop @res;
				push @res, -$temp1;
			}
			when ('^'){
				$temp2 = pop @res;
				$temp1 = pop @res;
				push @res, $temp1**$temp2;
			}
			when ('+'){
				$temp2 = pop @res;
				$temp1 = pop @res;
				push @res, $temp1+$temp2;
			}
			when ('-'){
				$temp2 = pop @res;
				$temp1 = pop @res;
				push @res, $temp1-$temp2;
			}
			when ('*'){
				$temp2 = pop @res;
				$temp1 = pop @res;
				push @res, $temp1*$temp2;
			}
			when ('/'){
				$temp2 = pop @res;
				$temp1 = pop @res;
				push @res, $temp1/$temp2;
			}
			default {
				die "Bad: '$_'";
			}
		}
	}

	return @res[scalar @res - 1];
}

1;
