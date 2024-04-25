create database if not exists QuanLyDatPhong;
use QuanLyDatPhong;
# drop database QuanLyDatPhong;
create table if not exists Category
(
    id     int primary key auto_increment,
    name   varchar(100) not null unique,
    status tinyint default 1 check ( status in (0, 1) )
);

create table if not exists Room
(
    id         int primary key auto_increment,
    name       varchar(150) not null unique,
    status     tinyint default 1 check ( status in (0, 1) ),
    price      float        not null check (price >= 100000),
    salePrice  float   default 0 ,
    createDate date    default (curdate()),
    categoryId int          not null
);

create trigger if not exists trg_checkSalePrice
    before insert
    on Room
    for each row
    begin

        if new.salePrice >= new.price then
            signal sqlstate '45000' set message_text = 'salePrice must less than price';
            end if;

    end;
create index index_room_name on Room (name);
create index index_room_price on Room (price);
create index index_room_createDate on Room (createDate);
alter table Room
    add constraint foreign key (categoryId)
        references Category (id);

create table if not exists Customer
(
    id          int primary key auto_increment,
    name        varchar(150) not null,
    email       varchar(150) not null unique check (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    phone       varchar(150) not null,
    address     varchar(150),
    gender      tinyint      not null check (gender in (1, 2)),
    createdDate date default (curdate()),
    birthDay    date         not null
);

create trigger if not exists trg_customer_createdDate
    before insert
    on Customer
    for each row
begin
    if new.createdDate < curdate() then
        signal sqlstate '45000' set message_text = 'created date must greater than now';

        end if;
end;

create table Booking
(
    id          int primary key auto_increment,
    customerId  int not null,
    status      tinyint  default 1 check ( status in (0,1, 2, 3) ),
    bookingDate Datetime default (curdate())
);
alter table  Booking drop column  status;
alter table  Booking add column  status  tinyint  default 1 check ( status in (0,1, 2, 3) );
alter table Booking
    add constraint foreign key (customerId)
        references Customer (id);


create table BookingDetail
(
    bookingId int      not null,
    roomId    int      not null,
    primary key (bookingId, roomId),
    price     float    not null,
    startDate Datetime not null,
    endDate   Datetime not null
);



create trigger trg_EndDate
    before insert
    on BookingDetail
    for each row
    begin
        if new.endDate <= new.startDate then
            signal sqlstate '45000' set message_text = 'endDate must greater than start date';
        end if;
    end;


alter table BookingDetail
    add constraint foreign key (bookingId)
        references Booking (id),
    add constraint foreign key (roomId)
        references Room (id)
;




