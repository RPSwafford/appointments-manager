#!/usr/bin/perl
use warnings;
use strict;

use HTML::Template;
use DBI;
use CGI;

use AppointmentsDb;

# All HTML is handled with template
my $template =
  HTML::Template->new(
    filename => '/usr/lib/cgi-bin/templates/appointments.tmpl' );

# Display page
print "Content-Type: text/html\n\n", $template->output;
#
# Get appointment parameters from client
my $q      = CGI->new;
my $month  = $q->param('month');
my $day    = $q->param('day');
my $year   = $q->param('year');
my $hour   = $q->param('hour');
my $minute = $q->param('minute');

my $date = "$month/$day/$year";
my $time = "$hour:$minute";

my $search_target = $q->param('search_target');

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
elsif ( $search_target =~ s/Ajax: // ) {

    # Ajax Get request
    my $appointments = AppointmentsDB->new;
    $appointments->build_appointment_list( $appointments->dbh() );
    $appointments->send_appointment_list;

}
