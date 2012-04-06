#!/usr/bin/perl

use File::Spec;

#use strict;
#use warnings;

# Prepare CSS for inclusion in a JavaScript string: escape quotes and remove
# newlines
sub prep_css {
	my $css = shift;
	my $quoteStr = shift;
	my $force_important = shift;

	$css =~ s/\n/ /g;
	$css =~ s/$quoteStr/\\$quoteStr/g;

	# Append "!important" to all rules (except those already specifying it)
	if ($force_important) {
		$css =~ s/\s*(!important)?\s*;/ !important;/g;
	}

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

	$contents =~ s/((["'])\s*!import_rule\s+(.+?)(!important)?\2)/
		lookup_css_rule($1, $2, $3, $4, \%all_rules)/ge;

	$contents =~ s/((["'])\s*!import_file\s+(.+?)(!important)?\2)/
		lookup_css_file($1, $2, $3, $4, $volume, $directory)/ge;

	return $contents;
}

# Given an "import rule" directive (and its component parts), either return a
# string containing either the CSS rule or (if the rule is not recognized) the
# original directive
sub lookup_css_rule {
	my $directive = shift;
	my $quote_str = shift;
	my $selectors = shift;
	my $force_important = shift;
	my $all_rules = shift;

	# Trim leading and trailing whitespace from the selectors
	$selectors =~ s/^\s+//;
	$selectors =~ s/\s+$//;

	# Exit with error status 1 if an unrecognized rule is encountered
	if ( !$all_rules->{$selectors} ) {
		exit 1;
	}

	return prep_css($all_rules->{$selectors}, $quote_str, $force_important);
}

# Given an "import file" directive (and its component parts), either return a
# string containing the contents of that file or (if the file is not readable)
# the original directive
sub lookup_css_file {
	my $directive = shift;
	my $quote_str = shift;
	my $file_name = shift;
	my $force_important = shift;
	my $rel_volume = shift;
	my $rel_directory = shift;

	# Trim leading and trailing whitespace from the filename
	$file_name =~ s/^\s+//;
	$file_name =~ s/\s+$//;

	my $full_name = File::Spec->catpath( $rel_volume, $rel_directory, $file_name );
	
	# Exit with error status 1 if an unreadable file was specified
	if( !-r $full_name ) {
		exit 1;
	}

	open( $handle, "<", $full_name ) || die "Can't open file '$full_name'";
	return prep_css(join('', <$handle>), $quote_str, $force_important);
}

%file_names = ( css, [], js, []);
%all_rules = ();

foreach $filename ( @ARGV ) {
	local $/ = undef;

	if (! -r $filename) {
		next;
	}

	if ($filename =~ /\.(css|js)$/) {
		push($file_names{$1}, $filename);
	}
}

foreach $filename (@{$file_names{css}}) {

	open( $handle, "<", $filename ) || die "Can't open file '$filename'";
	$str = join('', <$handle>);

	parse_rules( $str, \%all_rules);
}

foreach $filename (@{$file_names{js}}) {

	open( $handle, "<", $filename ) || die "Can't open file '$filename'";
	($volume,$directory,$file) = File::Spec->splitpath( $filename );
	$str = join('', <$handle>);
	print process_js($str, $volume, $directory, \%all_rules);
}
