package Local::JSONParser;

use strict;
use warnings;

use base qw(Exporter);
our @EXPORT_OK = qw( parse_json test_source );
our @EXPORT = qw( parse_json test_source );

use DDP;
use Encode;

sub hash {
	my $source = shift;
	my %res = ();
	my $key;
	my $value;
	$_ = $source;
	while (/
		(?<key>\".*\")
		:\s*
		(?<value>
		\{.*\}
		|\[.*\]
		|(\"
			(?:\\[\"\/bfnrt]
    	|\\u[0-9a-fA-f]{4}
			|\w
			|\s
			|\,
			)*
			\")
		|-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1}
		|true
		|false
		|null
		)( \,{0,1}|$ )/gx) {
			$key = test_source($+{key});
			$value = test_source($+{value});
			if (ref $value eq "HASH") {
				$res{$key} = %$value;
			} elsif (ref $value eq "ARRAY") {
				$res{$key} = @$value;
			} else {
				$res{$key} = $value;
			}
			p $key;
			p $value;
	}
	return %res;
}

sub array {
	my $source = shift;
	my @res = ();
	my $value;
	$_ = $source;
	while (/
		(?<value>
		\{.*\}
		|\[.*\]
		|(\"
			(?:\\[\"\/bfnrt]
    	|\\u[0-9a-fA-f]{4}
			|\w
			|\s
			|\,
			)*
			\")
		|-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1}
		|true
		|false
		|null
		)( \,{1}|$ )/gx) {
			$value = test_source($+{value});
			if (ref $value eq "HASH") {
				push @res, %$value;
			} elsif (ref $value eq "ARRAY") {
				push @res, @$value;
			} else {
				push @res, $value;
			}
	}
	return @res;
}

sub string {
	my $source = shift;
	$source =~ /\"
		((\\[\"\/bfnrt]
		|\\u[0-9a-fA-f]{4}
		|\w
		|\s
		|\,
		)*)
		\"/x;
	return $1;
}

sub number {
	my $source = shift;
	return $source;
}

sub test_source {
	my $source = shift;
	my $res;
	my @ares;
	my %hres;

	if ( $source =~ /^\{(.*)\}$/s ) {
		print "Here's a hash: $1\n";
		%hres = hash ($1);
		return \%hres;
	} elsif ( $source =~ /^\[(.*)\]$/s ) {
		print "Here's an array: $1\n";
		@ares = array ($1);
		return \@ares;
	} elsif ( $source =~ /^\"
		((\\[\"\/bfnrt]
		|\\u[0-9a-fA-f]{4}
		|\w
		|\s
		|\,
		)*)\"$/xs ) {
		print "Here's a string: $1\n";
		$res = string ($1);
		return $res;
	} elsif ( $source =~ /^(?<res>-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1})$/s ) {
		print "Here's a number: $+{res}\n";
		$res = number ($+{res});
		return $res;
	} else {
		die "Bad sequence";
	}
}

sub parse_json {
	my $source = shift;
	my $res = test_source ($source);
	#use JSON::XS;
	# return JSON::XS->new->utf8->decode($source);
	return $res;
}

1;
