#!/usr/bin/perl
use warnings;
use strict;

use HTML::Template;

my $template = HTML::Template->new(filename => 'templates/appointments.tmpl');
$template->param(error_message =>'The sky is falling!');
print "Content-Type: text/html\n\n", $template->output;
