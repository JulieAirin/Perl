=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

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
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub priority {
	my $op = shift;
	return
		$op eq '+' || $op eq '-' ? 1 :
		$op eq '*' || $op eq '/' ? 2 :
		$op eq '^' ? 3 :
		$op eq 'U+' || $op eq 'U-' ? 4 :
		-1;
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @ops;
	my @rpn;
	my $temp;

	for my $x (@$source) {
		given ($x) {
			when (/\d/) {
				push @rpn, $x;
			}
			when ('(') {
				push @ops, $x;
			}
			when (')') {
				$temp = pop @ops;
				while ($temp ne '(') {
					push @rpn, $temp;
					$temp = pop @ops;
				}
			}
			when ([ 'U+', 'U-', '^' ]){
				if (scalar @ops > 0) {
					while (priority($x) < priority(@ops[scalar @ops - 1])) {
						$temp = pop @ops;
						push @rpn, $temp;
						last if (scalar @ops == 0);
					}
				}
				push @ops, $x;
			}
			when ([ '+', '-', '*', '/' ]){
				if (scalar @ops > 0) {
					while (priority($x) <= priority(@ops[scalar @ops - 1])) {
						$temp = pop @ops;
						push @rpn, $temp;
						last if (scalar @ops == 0);
					}
				}
				push @ops, $x;
			}
			default {
				die "Bad: '$_'";
			}
		}
	}

	while (scalar @ops > 0) {
		$temp = pop @ops;
		push @rpn, $temp;
	}

	return \@rpn;
}

1;
