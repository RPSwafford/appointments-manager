package AppointmentsDb;

use DBI;

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

    my $rows_affected = $dbh->do(
        q{insert into appointment
        (date_time, description)
        values (?, ?)},
        undef,
        $date_time, $description
    );
    return $rows_affected;
}

1;
