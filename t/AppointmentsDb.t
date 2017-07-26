#!/usr/bin/perl
#use warnings;
#use strict;

use Test::More tests => 2;

use AppointmentsDb;

my $appointments_db = AppointmentsDb->new, 'AppointmentsDb';
isa_ok $appointments_db, 'AppointmentsDb';

my $seconds = sprintf "%02d", ( localtime(time) )[0];
is $appointments_db->insert( "2017-07-10 15:30:$seconds", 'car repair' ), 1,
  'AppointmentsDb::insert';

$appointments_db->build_appointment_list;
