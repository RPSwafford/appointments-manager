package AppointmentsDb;
use strict;
use warnings;

use DBI;
use feature 'say';

#Attributes:
my $dbh;

sub new () {
    my $class = shift or die 'Specify class or object';
    $dbh = DBI->connect( 'dbi:mysql:appointments', 'root', '53r3n1ty' )
      or die 'Unable to connect to db: ' . DBI->errstr;
    return bless { dbh => $dbh }, ref $class || $class;
}

sub insert {
    my $this = shift;
    my ( $date_time, $description ) = @_
      or die "Usage: insert date_time description";

    print "AppointmentDB: date_time: $date_time\n";
    print "AppointmentDB: description: $description\n";

    my $rows_affected = $dbh->do(
        q{insert into appointment
        (date_time, description)
        values (?, ?)},
        undef,
        $date_time, $description
    );
    return $rows_affected;
}

sub build_appointment_list {
    my $this                 = shift;
    my $appointment_list_ref = $dbh->selectall_arrayref(
        'select date_time, description from appointment');

    my $appointments = "{ appointments: [\n";
    foreach my $row (@$appointment_list_ref) {
        my ( $datetime, $description ) = @$row;
        my ( $date, $time ) = split ' ', $datetime;
        $appointments .=
"  { \"date\":\"$date\", \"time\":\"$time\", \"description\":\"$description\"},\n";
    }

    # Remove terminating comma from last element of list.
    $appointments =~ s/,\n$/\n/;

    $appointments .= ']);';
    print $appointments;
}

sub send_appointment_list {
    my $this = shift;

    # Send appointment list to client somehow.  Client must convert it from
    # JSON to HTML table rows (<tr>'s full of <td>'s.
}

# Accessor method
sub dbh() {
    my $this = shift;
    return $this->{dbh};
}

1;
