package Local::JSONParser;

use strict;
use warnings;

use base qw(Exporter);
our @EXPORT_OK = qw( parse_json test_source );
our @EXPORT = qw( parse_json test_source );

use DDP;
use Encode;
use utf8;

sub hash {
	my $source = shift;
	my %res = ();
	my $key;
	my $value;
	while ($source =~ /
		(?<key>"(?:\\["\/bfnrt]
    	|\\u[0-9a-fA-F]{4}
			|\w
			|\s
			|\,
			)*
		")
		\s*:\s*
		(?<value>
		\{.*\}
		|\[.*\]
		|("
			(?:\\["\/bfnrt]
    	|\\u[0-9a-fA-F]{4}
			|\w
			|\s
			|\d
			|@|\{|\}|\[|\]|:|\+
			|\,
			)*
		")
		|-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1}
		|true
		|false
		|null
		)( \,?|$ )/gx) {
			$key = test_source($+{key});
			$value = test_source($+{value});
			if (ref $value eq "HASH") {
				$res{$key} = $value;
			} elsif (ref $value eq "ARRAY") {
				$res{$key} = $value;
			} else {
				$res{$key} = $value;
			}
	}
	return %res;
}

sub array {
	my $source = shift;
	my @res = ();
	my $value;
	while ($source =~ /
		(?<value>
		\{.*\}
		|\[.*\]
		|("
			(?:\\["\/bfnrt]
    	|\\u[0-9a-fA-F]{4}
			|\w
			|\s
			|\d
			|\,
			|@|\{|\}|\[|\]|:|\+
			)*
			")
		|-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1}
		|true
		|false
		|null
		)( ,?|$ )/gx) {
			$value = test_source($+{value});
			if (ref $value eq "HASH") {
				push @res, $value;
			} elsif (ref $value eq "ARRAY") {
				push @res, $value;
			} else {
				push @res, $value;
			}
	}
	return @res;
}

sub string {
	my $source = shift;
	$source =~ /"
		((\\["\/bfnrt]
		|\\u[0-9a-fA-F]{4}
		|\w
		|\d
		|\s
		|@|\{|\}|\[|\]|:|\+|\,
		)*)
		"/x;
	my $res = $1;
	$res =~ s/\\u([0-9A-Fa-f]{4})/chr hex $1/eg;
	$res =~ s/(\\b)/chr(8)/eg;
	$res =~ s/(\\f)/chr(12)/eg;
	$res =~ s/(\\n)/chr(10)/eg;
	$res =~ s/(\\r)/chr(13)/eg;
	$res =~ s/(\\t)/chr(9)/eg;
	$res =~ s/\\"/"/g;
	$res =~ s/\\\//\//g;
	return $res;
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
		%hres = hash ($1);
		return \%hres;
	} elsif ( $source =~ /^\[(.*)\]$/s ) {
		@ares = array ($1);
		return \@ares;
	} elsif ( $source =~ /^"
		((\\["\/bfnrt]
		|\\u[0-9a-fA-F]{4}
		|\w
		|\s
		|\d
		|@|\{|\}|\[|\]|:|\+
		|\,
		)*)"$/xs ) {
		$res = string ($1);
		return $res;
	} elsif ( $source =~ /^(?<res>-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1})$/s ) {
		$res = number ($+{res});
		return $res;
	} else {
		die "Bad sequence";
	}
}

sub parse_json {
	my $source = shift;
	my $res = test_source (decode("utf-8",$source));
	#use JSON::XS;
	#return JSON::XS->new->utf8->decode($source);
	return $res;
}

1;
