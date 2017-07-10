use appointments;
DROP TABLE IF EXISTS `appointment`;
create table appointment (
    date_time datetime,
    description varchar(40),
    primary key (date_time)
) ENGINE=InnoDB;
