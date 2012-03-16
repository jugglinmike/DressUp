#!/usr/bin/perl

use File::Spec;

#use strict;
#use warnings;

# Prepare CSS for inclusion in a JavaScript string: escape quotes and remove
# newlines
sub prep_css {
	my $css = shift;
	my $quoteStr = shift;

	$css =~ s/\n/ /g;
	$css =~ s/$quoteStr/\\$quoteStr/g;

	return $quoteStr . $css . $quoteStr;
}

sub parse_rules {
	my $contents = shift;
	# Reference to a hash of all CSS rules
	my $allRules = shift;

	while( $contents =~ /([^{]+){([^}]+)}/g ) {
		$selectors = $1;
		$declarations = $2;

		# Trim whitespace from ends of selectors and decarations
		$selectors =~ s/^\s+|\s+$//g;
		$declarations =~ s/^\s+|\s+$//g;

		$allRules->{$selectors} = $declarations;
	}
}

sub process_js {
	my $contents = shift;
	my $volume = shift;
	my $directory = shift;
	my $all_rules = shift;

	$contents =~ s/((["'])\s*!import_rule\s+(.+)\2)/
		lookup_css_rule($1, $2, $3, \%all_rules)/ge;

	$contents =~ s/((["'])\s*!import_file\s+(.+)\2)/
		lookup_css_file($1, $2, $3, $volume, $directory)/ge;

	return $contents;
}

# Given an "import rule" directive (and its component parts), either return a
# string containing either the CSS rule or (if the rule is not recognized) the
# original directive
sub lookup_css_rule {
	my $directive = shift;
	my $quote_str = shift;
	my $selectors = shift;
	my $all_rules = shift;

	if ( $all_rules->{$selectors} ) {
		return prep_css($all_rules->{$selectors}, $quote_str);
	}

	return $directive;
}

# Given an "import file" directive (and its component parts), either return a
# string containing the contents of that file or (if the file is not readable)
# the original directive
sub lookup_css_file {
	my $directive = shift;
	my $quote_str = shift;
	my $file_name = shift;
	my $rel_volume = shift;
	my $rel_directory = shift;

	my $full_name = File::Spec->catpath( $rel_volume, $rel_directory, $file_name );
	
	if( !-r $full_name ) {
		return $directive;
	}

	open( $handle, "<", $full_name ) || die "Can't open file '$full_name'";
	return prep_css(join('', <$handle>), $quote_str);
}

#%thing = ('matt', 30);
#$tmp = "div.csc { z-index: 3; } div.bbd { z-index: 5; }";
#parse_rules($tmp, \%thing);
#for (keys %thing)
#{
#	print $_, ": ", $thing{$_}, "\n";
#}

#{
#	local $/ = undef;
#	open(INFILE, $ARGV[0]) or die "Couldn't open file: '$ARGV[1]'";
#	$contents = <INFILE>;
#	close INFILE;
#}

%file_names = ( css, [], js, []);
%all_rules = ();

foreach $filename ( @ARGV ) {
	local $/ = undef;

#	open(INFILE, $filename) or die "Couldn't open file: '$filename'";
#	print $filename, "\n";
#	$contents = <INFILE>;
#	close INFILE;

	if (! -r $filename) {
		next;
	}

	if ($filename =~ /\.(css|js)$/) {
		push($file_names{$1}, $filename);
#		$contents = input => $contents;
#		while ($contents =~ /([^{]+)\s*{([^}]+)}/g) {
#			$selectors = $1;
#			$declarations = $2;
#			$declarations =~ s/\n//g;
#			print "- ", $selectors, ": ", $declarations, "\n";
#		}
	}
	#print <INFILE>;
}

foreach $filename (@{$file_names{css}}) {

	open( $handle, "<", $filename ) || die "Can't open file '$filename'";
	$str = join('', <$handle>);

	parse_rules( $str, \%all_rules);
}

#foreach $selectors (keys %all_rules) {
#	print "$selectors: '", prep_css($all_rules{$selectors}, "'"), "'\n";
#}

foreach $filename (@{$file_names{js}}) {

	open( $handle, "<", $filename ) || die "Can't open file '$filename'";
	($volume,$directory,$file) = File::Spec->splitpath( $filename );
	$str = join('', <$handle>);
	print process_js($str, $volume, $directory, \%all_rules);
}
