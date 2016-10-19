=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

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

sub tokenize ($) {
	chomp(my $expr = shift);
	my @res;
	my $counter = 0;
	my $prev = '%';
	my @source = split m{((?<!e)[-+]|[*()/^]|\s+)}, $expr;
	my $lastTokenIsNumber = 0;
	for my $x (@source) {
		given ($x) {
			when (/^\s*$/) {} # пропустить, если пустая строка или пробелы
			when (/\d/) { # элемент содержит цифру
				if (/^\d*\.?\d+([e][+-]?\d+)?$/) {
					$x = 0 + $x;
					push @res, "$x";
					$prev = $x;
					$lastTokenIsNumber = 1;
				} else {
					die "Bad: '$_'";
				}
			}
			when ([ '+','-' ]){ # элемент "+" или "-"
				if (($prev eq ')') || ($prev =~ /\d/)) {
					push @res, $x;
					$prev = $x;
				} else {
					$prev = 'U'.$x;
					push @res, $prev;
				}
				$lastTokenIsNumber = 0;
			}
			when ([ '*','/' ]){
				if (($prev eq ')') || ($prev =~ /\d/)) {
					push @res, $x;
					$prev = $x;
					$lastTokenIsNumber = 0;
				} else {
					die "Error: sequence of ops";
				}
			}
			when ('^') {
				if (($prev eq ')') || ($prev =~ /\d/)) {
					push @res, $x;
					$prev = $x;
					$lastTokenIsNumber = 0;
				} else {
					die "Error: sequence of ops";
				}
			}
			when ([ '(',')' ]) {
					if ($x eq '(') {
						$counter++;
					} else {
						$counter--;
					}
					if ($prev =~ /\d/) {
						$lastTokenIsNumber = 1;
					} else {
						$lastTokenIsNumber = 0;
					}
					push @res, $x;
					$prev = $x;
			}
			default {
				die "Bad: '$_'";
			}
		}
	}
	if ($counter != 0) {
		die "Error: wrong sequence of brackets";
	}
	if ($lastTokenIsNumber != 1) {
		die "Error: no numbers in the end";
	}
	return \@res;
}

1;
