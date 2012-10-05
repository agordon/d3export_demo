#!/usr/bin/env perl
=pod
This is a proof-of-concept demo for saving d3js graphics as PDF/PNG/SVG files.

Copyright (C) 2012 by A. Gordon (gordon at cshl dot edu)
All code written by me is released under BSD license: http://opensource.org/licenses/BSD-3-Clause
(also uses several other libraries that have their own licenses).

See here for more details:
	https://github.com/agordon/d3export_demo

See here for online demo:
	http://d3export.cancan.cshl.edu/
=cut
use strict;
use warnings;
use CGI qw/:standard/;
use CGI::Carp qw/fatalsToBrowser/;
use autodie qw(:all);
use File::Temp qw/tempfile/;
use File::Slurp qw/read_file write_file/;

=pod
Minimal, bare-bores implementation of a CGI script,
which runs "rsvg-convert" on the submitted input data.

No fluff, no "frame-works", no pretty HTML/CSS.

Note about error checking:
autodie + CGI::Carp will take care of all the errors.
In a proper application, you'll want to replace those with proper error handling.
=cut


# Limit the size of the POST'd data - might need to increase it for hudge d3js drawings.
$CGI::POST_MAX = 1024 * 5000;

##
## Input validation
##
my $output_format = param('output_format')
	or die "Missing 'output_format' parameter";
die "Invalid output_format value"
	unless $output_format eq "svg" ||
		$output_format eq "pdf" ||
		$output_format eq "png";

my $data = param('data')
	or die "Missing 'data' parameter";
die "Invalid data value"
	unless $data =~ /^[\x20-\x7E\t\n\r ]+$/;


##
## Output Processing
##

## SVG output
if ($output_format eq "svg") {
	## If both input & output are SVG, simply return the submitted SVG
	## data to the user.
	## The only reason to use a server side script is to be able to offer
	## the user a friendly way to "download" a file as an attachment.
	print header(-type=>"image/svg+xml",
		     -attachment=>"d3js_export_demo.svg");
	print $data;
	exit(0);
}
## PDF/PNG output
elsif ($output_format eq "pdf" || $output_format eq "png") {
	# Create temporary files (will be used with 'rsvg-convert')
	my (undef, $input_file) = tempfile("d3export.svg.XXXXXXX", OPEN=>0, TMPDIR=>1, UNLINK=>1);
	my (undef, $output_file) = tempfile("d3export.out.XXXXXXX", OPEN=>0, TMPDIR=>1, UNLINK=>1);

	# Write  the SVG data to a temporary file
	write_file( $input_file, $data );

	my $zoom = ($output_format eq "png")?10:1;

	# Run "rsvg-convert", create the PNG/PDF file.
	system("rsvg-convert -o '$output_file' -z '$zoom' -f '$output_format' '$input_file'");

	# Read the binary output (PDF/PNG) file.
	my $pdf_data = read_file( $output_file, {binmode=>':raw'});

	## All is fine, send the data back to the user
	my $mime_type = ($output_format eq "pdf")?"application/x-pdf":"image/png";
	print header(-type=>$mime_type,
		     -attachment=>"d3js_export_demo.$output_format");
	print $pdf_data;

	exit(0);
}

