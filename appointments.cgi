#!/usr/bin/perl
use warnings;
use strict;

use HTML::Template;
use DBI;
use CGI;

use AppointmentsDb;

#Display page
my $template = HTML::Template->new( filename => '/usr/lib/cgi-bin/templates/appointments.tmpl' );
print "Content-Type: text/html\n\n", $template->output;

# Get appointment parameters from client
my $q           = CGI->new;
my $date        = $q->param('date');
my $time        = $q->param('time');

# Accommadate MySQL DATETIME format.
my $date_time   = "$date $time";

my $description = $q->param('description');

if ( $date_time && $description ) {

    # update appointment database
    eval {
        my $appointment_db = AppointmentsDB->new;
        $appointment_db->insert( $date_time, $description );
    };
    if ($@) {
        $template->param(
            error_message => "Error updating appointments database\n$@" );
    }
}
elsif ( 1 ) {
#  jason
         
}
else {
#  Basic Page
}

