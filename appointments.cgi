#!/usr/bin/perl
use warnings;
use strict;

use HTML::Template;
use DBI;
use CGI;

# Get appointment parameters from client
my $q    = CGI->new;
my $date = $q->param('date');
my $time = $q->param('time');

# All HTML is handled with template
my $template =
  HTML::Template->new(
    filename => '/usr/lib/cgi-bin/templates/appointments.tmpl' );

# Accommadate MySQL DATETIME format.
my $date_time = "$date $time";

my $description = $q->param('description');

if ( $date_time && $description ) {

    # update appointment database from form submission.
    eval {
        my $appointment_db = AppointmentsDB->new;
        $appointment_db->insert( $date_time, $description );
    };
    if ($@) {
        $template->param(
            error_message => "Error updating appointments database\n$@" );
    }
}
elsif ( 0 ) {  # Need way to tell AJAX GET from form-submit GET

    # Ajax
    my $appointments = AppointmentsDB->new;
    $appointments->build_appointment_list($appointments->dbh());
    $appointments->send_appointment_list;

}

# Display page
print "Content-Type: text/html\n\n", $template->output;

