create table Department
(
    Id   int primary key auto_increment,
    Name Varchar(100) unique not null check (length(Name) > 6)
);

create table Levels
(
    Id              int primary key auto_increment,
    Name            Varchar(100) unique not null,
    BasicSalary     Float               not null check (BasicSalary >= 3500000),
    AllowanceSalary Float default 500000
);

create table Employee
(
    Id           int primary key auto_increment,
    Name         Varchar(150) not null,
    Email        Varchar(150) not null unique check (Email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    Phone        varchar(50)  not null unique,
    Address      varchar(255),
    gender       tinyint      not null check ( gender = 0 or 1 or 2 ),
    Birthday     date         not null,
    levelId      int          not null,
    departmentId int          not null
);
alter table Employee
    add constraint fk_Employee_levelId
        foreign key (levelId) references Levels (Id),
    add constraint fk_Employee_departmentId
        foreign key (departmentId) references Department (Id);


create table TimeSheets
(
    Id             int primary key auto_increment,
    AttendanceDate datetime not null default now(),
    employeeId     int      not null,
    value          float    not null default 1 check (value = 0 or 0.5 or 1)
);

alter table TimeSheets
    add constraint fk_TimeSheets_employId
        foreign key (employeeId) references Employee (Id);


create table Salary
(
    Id             int primary key auto_increment,

    AttendanceDate datetime not null default now(),
    employeeId     int      not null,
    BonusSalary    float    not null default 0,
    Insurrance     float    not null

);



create trigger tr_getInsurrance
    before insert
    on Salary
    for each row
    begin
        declare baseSalary float;
        select BasicSalary into baseSalary from Levels L
            join Employee e on e.levelId = l.Id;
        set new.Insurrance = baseSalary * 0.1;

    end;

# New luu tru du lieu trc khi chen vào bảng. trigger dù có thành công hay thất bại thì vẫn chạy bên trong

alter table Salary
    add constraint fk_Salary_employId
        foreign key (employeeId) references Employee (Id);

INSERT INTO Department (Name)
VALUES ('HR Department'),
       ('Finance Department'),
       ('IT Department');

-- Thêm dữ liệu vào bảng Levels
INSERT INTO Levels (Name, BasicSalary, AllowanceSalary)
VALUES ('Junior', 4000000, 500000),
       ('Senior', 6000000, 700000),
       ('Manager', 8000000, 1000000);

-- Thêm dữ liệu vào bảng Employee
INSERT INTO Employee (Name, Email, Phone, Address, gender, Birthday, levelId, departmentId)
VALUES ('John Doe', 'john@example.com', '123456789', '123 Main St', 1, '1999-01-01', 1, 1),
       ('Alice Smith', 'alice@example.com', '987654321', '456 Elm St', 0, '1997-05-05', 2, 2),
       ('Hieu Johnson', 'bob2@example.com', '113222333', '789 Oak St', 1, '1977-08-10', 3, 3),
       ('Bob Demo', 'test@example.com', '111224333', '789 Oak St', 1, '1984-08-10', 1, 3),
       ('Bob Java', 'demo@example.com', '111225333', '789 Oak St', 0, '1983-08-10', 3, 2),
       ('Go Johnson', 'bo1@example.com', '111262333', '789 Oak St', 1, '1982-08-10', 2, 1),
       ('Lambda', 'bobtest2@example.com', '111222373', '789 Oak St', 0, '1981-08-10', 1, 1),
       ('Lee All', 'alpha@example.com', '111228333', '789 Oak St', 1, '1995-08-10', 2, 2),
       ('Rikkei ', 'java@example.com', '111222933', '789 Oak St', 0, '1975-08-10', 3, 3),
       ('Japan', 'bob4@example.com', '111221339', '789 Oak St', 1, '1986-08-10', 2, 1),
       ('China', 'bob3@example.com', '111223339', '789 Oak St', 0, '1984-08-10', 1, 2),
       ('Alpha', 'lala@example.com', '111222383', '789 Oak St', 0, '1985-08-10', 2, 1),
       ('Amazon', 'yaya1@example.com', '111226333', '789 Oak St', 0, '1985-08-10', 3, 2),
       ('Microsoft', 'text2@example.com', '117222333', '789 Oak St', 1, '1985-08-10', 3, 3),
       ('Google', 'hihi@example.com', '111222333', '789 Oak St', 1, '1985-08-10', 3, 3);
-- Thêm thêm các bản ghi Employee ở đây cho đến tổng số 15 bản ghi

-- Thêm dữ liệu vào bảng TimeSheets
INSERT INTO TimeSheets (AttendanceDate, employeeId, value)
VALUES ('2024-04-01 08:00:00', 17, 1),
       ('2024-04-02 08:00:00', 16, 0.5),
       ('2024-04-03 01:00:00', 17, 1),
       ('2024-04-04 01:00:00', 18, 0),
       ('2024-03-05 07:00:00', 19, 1),
       ('2024-02-06 07:00:00', 18, 0.5),
       ('2024-01-07 07:00:00', 16, 1),
       ('2024-12-01 08:00:00', 17, 0),
       ('2024-11-09 08:00:00', 18, 1),
       ('2024-010-10 08:00:00', 16, 0.5),
       ('2024-09-11 08:00:00', 21, 1),
       ('2024-08-12 08:00:00', 19, 0),
       ('2024-07-13 08:00:00', 18, 1),
       ('2024-06-14 08:00:00', 17, 0.5),
       ('2024-05-15 08:00:00', 16, 1),
       ('2024-04-16 11:00:00', 17, 0),
       ('2024-04-17 11:00:00', 21, 1),
       ('2024-04-18 11:00:00', 22, 0.5),
       ('2024-04-19 11:00:00', 23, 1),
       ('2024-04-20 11:00:00', 24, 0.5),
       ('2024-04-20 11:00:00', 25, 0.5),
       ('2024-04-20 08:00:00', 26, 0),
       ('2024-04-20 03:00:00', 27, 0),
       ('2024-04-20 03:00:00', 28, 0),
       ('2024-04-20 03:00:00', 29, 0),
       ('2024-04-20 03:00:00', 22, 0),
       ('2024-04-20 08:00:00', 23, 1),
       ('2024-04-20 08:00:00', 21, 1),
       ('2024-04-20 08:00:00', 21, 1),
       ('2024-04-20 08:00:00', 25, 1);
-- Thêm thêm các bản ghi TimeSheets ở đây cho đến tổng số 30 bản ghi

-- Thêm dữ liệu vào bảng Salary
INSERT
INTO Salary (AttendanceDate, employeeId, BonusSalary, Insurrance)
VALUES ('2024-04-01 08:00:00', 16, 1000000, 500000),
       ('2024-04-01 08:00:00', 21, 500000, 300000),
       ('2024-04-01 08:00:00', 23, 600000, 100000),
       ('2024-04-01 08:00:00', 24, 700000, 400000),
       ('2024-04-01 08:00:00', 25, 800000, 500000),
       ('2024-04-01 08:00:00', 26, 900000, 600000),
       ('2024-04-01 08:00:00', 27, 1100000, 700000),
       ('2024-04-01 08:00:00', 30, 1500000, 600000),
       ('2024-04-01 08:00:00', 29, 500000, 640000),
       ('2024-04-01 08:00:00', 28, 300000, 650000),
       ('2024-04-01 08:00:00', 18, 200000, 670000);

#####Yeu Cau 1
#1
select em.id,
       em.name,
       em.email,
       em.phone,
       em.address,
       em.gender,
       em.birthday,
       D.Name,
       L.Name

from Employee em
         join Levels L on em.levelId = L.Id
         join Department D on em.departmentId = D.Id
order by em.Name;

#2
select S.Id,
       E.Name,
       E.Phone,
       E.Email,
       L.BasicSalary,
       L.AllowanceSalary,
       S.BonusSalary,
       S.Insurrance,
       SUM(L.BasicSalary * L.AllowanceSalary) As TotalSalary

from Salary S
         join Employee E on S.employeeId = E.Id
         join Levels L on E.levelId = L.Id
group by S.Id, E.Name, E.Phone, E.Email, L.BasicSalary, L.AllowanceSalary, S.BonusSalary, S.Insurrance;

#3

select D.Id, D.Name, count(Employee.departmentId) as TotalEmployee

from Employee
         join Department D on Employee.departmentId = D.Id
group by D.Id, D.Name;

#4

# update Salary set BonusSalary = BonusSalary* 1.1

update Salary
set BonusSalary = BonusSalary * 1.1
where employeeId in ((select TimeSheets.employeeId
                      from TimeSheets
                      where MONTH(TimeSheets.AttendanceDate) = 4
                    and YEAR(TimeSheets.AttendanceDate) = 2024
                      group by TimeSheets.employeeId
                      having count(TimeSheets.employeeId) > 2));

#5
delete
from Department
where Id not in (select DepartmentId.Id
                 from (select D.Id
                       from Department D
                                join Employee E on D.Id = E.departmentId) as DepartmentId);



#####Yeu Cau 2
#1
create view v_getEmployeeInfo
as
select E.Id
     , e.Name as EmployeeName
     , e.Email
     , e.Phone
     , e.Address
     , e.Birthday
     , D.Name as DepartmentName
     , L.Name as LevelName
     , case
           when E.gender = 1 then 'Nam'
           when E.gender = 0 then 'Nu'
    end
from Employee E
         join Levels L on E.levelId = L.Id
         join Department D on E.departmentId = D.Id;

select *
from v_getEmployeeInfo;

#2
create view v_getEmployeeSalaryMax
as
select E.Id,
       e.Name                                             as EmployeeName,
       e.Email,
       e.Birthday,
       (select sum(Total) as GrandTotal
        from (select count(employeeId) as Total
              from TimeSheets
              where MONTH(AttendanceDate) = 4
              group by employeeId
              having count(employeeId) > 3) as DemoTotal) as TotalThatMonth
from Employee E
         join TimeSheets TS on TS.employeeId = E.Id
where e.Id in (select employeeId
               from TimeSheets
               where MONTH(AttendanceDate) = 4
               group by employeeId
               having count(employeeId) > 3)
group by E.Id, e.Name, e.Email, e.Birthday;

select *
from v_getEmployeeSalaryMax;

#####Yeu Cau 3
#1
delimiter //
create procedure addEmployeetInfo(in name_in varchar(150),
                                  in email_in varchar(150),
                                  in phone_in varchar(50),
                                  in address_in varchar(255),
                                  in gender_in tinyint,
                                  in birthday_in date,
                                  in levelId_in int,
                                  in departmentId_in int
)
begin
    insert into Employee (Name, Email, Phone, Address, gender, Birthday, levelId, departmentId)
    values (name_in, email_in, phone_in, address_in, gender_in, birthday_in, levelId_in, departmentId_in);

end;
//

call addEmployeetInfo('java', 'javapro@gmail.com', '0934123123', 'japan', 1, '2024-02-02', 3, 2);


#2
delimiter //
create procedure getSalaryByEmployeeId(in monthSalary int)
begin
    select E.Id
         , E.Name
         , e.Phone
         , e.Email
         , l.BasicSalary
         , l.AllowanceSalary
         , s.BonusSalary
         , s.Insurrance
         , count(e.Id)                                                             as Todayday
         , sum((l.BasicSalary + l.AllowanceSalary + s.BonusSalary) - s.Insurrance) as TotalSalary

    from Employee E
             join Salary S on S.employeeId = E.Id
             join TimeSheets TS on TS.employeeId = e.Id
             join Levels L on E.levelId = L.Id
    where MONTH(TS.AttendanceDate) = MONTH(now())
    group by E.Id, E.Name, e.Phone, e.Email, l.BasicSalary, l.AllowanceSalary, s.BonusSalary, s.Insurrance;


end;
call getSalaryByEmployeeId(4);

#3
delimiter //
create procedure getEmployeePaginate(in pageNumber int,
                                     in limited int
)
begin
    declare offset int;

    set offset = (limited * pageNumber) - limited;

    select *
    from Employee
    limit limited
        offset offset;
#     limit off_set,size;

end;
//

call getEmployeePaginate(2, 4);

#####Yeu Cau 4
#1

create trigger tr_check_insurrance_value
    before insert
    on Salary
    for each row
    begin

    declare baseSalary float;
       select BasicSalary into baseSalary from Levels L
           join Employee e on e.levelId = L.Id
    where e.id = new.employeeId;
        if new.Insurrance <> baseSalary * 0.1
            then
            signal sqlstate '45000' set message_text  = "Giá trị của Insurrance phải = 10% của BasicSalary";

        end if ;

    end //

create trigger tr_check_basic_salary
    before insert
    on Levels
    for each row
    begin
        if new.BasicSalary > 10000000
            then
            set new.BasicSalary = 10000000;
            signal sqlstate '45000' set message_text = '...';
        end if ;
    end ;//
