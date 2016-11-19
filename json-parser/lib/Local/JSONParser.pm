package Local::JSONParser;

use strict;
use warnings;

use base qw(Exporter);
our @EXPORT_OK = qw( parse_json test_source );
our @EXPORT = qw( parse_json test_source );

use DDP;

sub hash {
	my $source = shift;
	my %res = ();
	my $key;
	$_ = $source;
	while (/
		(?<key>\".*\")
		:\s*
		(?<value>
		\{.*\}
		|\[.*\]
		|\".*\"
		|-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1}
		|true
		|false
		|null
		)( \,{1}|$ )/gx) {
			print test_source($+{key}).": ".test_source($+{value})."\n";
	}
}

sub array {
	my $source = shift;
	my @res = ();
	$_ = $source;
	while (/
		(?<value>
		\{.*\}
		|\[.*\]
		|\".*\"
		|-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1}
		|true
		|false
		|null
		)( \,{1}|$ )/gx) {
			print test_source($+{value})."\n";
	}
}

sub string {
	my $source = shift;
	print $source;
}

sub number {
	my $source = shift;
	print $source;
}

sub test_source {
	my $source = shift;
	my $res;
	my @ares;
	my %hres;

	if ( $source =~ /^\{(.*)\}$/s ) {
		#%hres = %{hash ($1)};
		hash ($1);
		return %hres;
	} elsif ( $source =~ /^\[(.*)\]$/s ) {
		@ares = array ($1);
		return @ares;
	} elsif ( $source =~ /^\"(.*)\"$/s ) {
		$res = string ($1);
	} elsif ( $source =~ /^(?<res>-{0,1}([1-9][0-9]*|0)(\.[0-9]*){0,1}([eE][\+-]{0,1}[0-9]){0,1})$/s ) {
		$res = number ($+{res});
	} else {
		die "Bad sequence";
	}
	return $res;
}

sub parse_json {
	my $source = shift;
	test_source ($source);
	#use JSON::XS;

	# return JSON::XS->new->utf8->decode($source);
	return {};
}

1;
