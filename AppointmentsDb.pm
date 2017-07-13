package AppointmentsDb;

use DBI;
use feature 'say';

# database handle
my $dbh;

sub new () {
    my $class = shift or die 'Specify class or object';
    $dbh = DBI->connect( 'dbi:mysql:appointments', 'root', '53r3n1ty' )
      or die 'Unable to connect to db: ' . DBI->errstr;
    return bless { dbh => $dbh }, ref $class || $class;
}

sub insert {
    my $this = shift;
    print "AppointmentDB: date_time: $date_time\n";
    print "AppointmentDB: description: $description\n";
    my ( $date_time, $description ) = @_
      or die "Usage: insert date_time description";

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
    my $this = shift;
    my ($dbh) = @_;
    my $appointment_list_ref = $dbh->selectall_array_ref(
        'select datetime, description from appointment');

    # die will be caught with eval and $@
    open my $fh, ">", "appointment_list.json"
      or die "Cannot open appointment_list.json: $!";

    print $fh "{ ";
    foreach my $row (@$appointment_list_ref) {
        my ( $datetime, $description ) = @$row;
        my ( $date, $time ) = split ' ', $datetime;
        print $fh
"{ \"date\":\"$date\", \"time\":\"$time\":\"description\":\"$description\"}\n";
    }
    close $fh or die "Error closing appointment_list.json: $!";
}

sub send_appointment_list {
    my $this = shift;
    # Send appointment list as to client somehow.  Client must convert it from
    # JSON to HTML table rows (<tr>'s full of <td>'s.
}

sub dbh() {
    my $this = shift;
    return $this->{dbh};
}

1;
