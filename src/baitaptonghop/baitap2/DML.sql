-- Chèn dữ liệu vào bảng Category
use QuanLyDatPhong;
INSERT INTO Category (name, status) VALUES
                                        ('Category 1', 1),
                                        ('Category 2', 1),
                                        ('Category 3', 1),
                                        ('Category 4', 1),
                                        ('Category 5', 1);
INSERT INTO Room (name, status, price, categoryId) VALUES
                                                       ('Room 1', 1, 150000, 1),
                                                       ('Room 2', 1, 200000, 2),
                                                       ('Room 3', 1, 180000, 3),
                                                       ('Room 4', 1, 220000, 4),
                                                       ('Room 5', 1, 250000, 5),
                                                       ('Room 6', 1, 170000, 1),
                                                       ('Room 7', 1, 190000, 2),
                                                       ('Room 8', 1, 210000, 3),
                                                       ('Room 9', 1, 230000, 4),
                                                       ('Room 10', 1, 260000, 5),
                                                       ('Room 11', 1, 175000, 1),
                                                       ('Room 12', 1, 185000, 2),
                                                       ('Room 13', 1, 195000, 3),
                                                       ('Room 14', 1, 205000, 4),
                                                       ('Room 15', 1, 215000, 5);

INSERT INTO Customer (name, email, phone, address, gender, birthDay) VALUES
                                                                         ('John Doe', 'john.doe@example.com', '123456789', '123 Main Street', 1, '1990-01-01'),
                                                                         ('Alice Smith', 'alice.smith@example.com', '987654321', '456 Oak Avenue', 2, '1995-05-15'),
                                                                         ('Bob Johnson', 'bob.johnson@example.com', '456789123', '789 Elm Street', 1, '1985-10-20'),
                                                                         ('Emily Brown', 'emily.brown@example.com', '321654987', '987 Pine Street', 2, '1988-03-10');

INSERT INTO Booking (customerId, status, bookingDate) VALUES
                                                          (1, 1, NOW()),
                                                          (2, 1, NOW()),
                                                          (3, 2, NOW()),
                                                          (4, 3, NOW());
INSERT INTO BookingDetail (bookingId, roomId, price, startDate, endDate) VALUES
                                                                                     (1, 1, 150.00, '2024-02-24', '2024-09-24'),
                                                                                     (1, 2, 200.00, NOW(), '2024-08-24'),
                                                                                     (2, 3, 180.00, '2024-05-24', '2024-06-24'),
                                                                                     (2, 4, 220.00, NOW(), '2024-07-24');

#Yeu Cau 1
#1
select R.Id, R.Name as RoomName, r.Price, r.SalePrice, r.Status, CT.Name, r.createDate
from Room R join
    Category CT on CT.id = R.categoryId
order by r.price desc;


# Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )

    select  CT.Id, ct.Name, r.Status, count(r.id)
        from Category CT join Room R on r.categoryId = CT.id
    where r.status = 1
    group by CT.Id;



# Truy vấn danh sách Customer gồm:
# Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay,
# Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )

    select Id, Name, Email, Phone, Address, CreatedDate,
           case
               when gender = 2 then 'Nam'
                   when gender = 1 then 'Nu'
                       end
           , BirthDay,
           (YEAR(curdate()) - YEAR(birthDay) ) as age
    from Customer;



#Truy vấn xóa các sản phẩm chưa được bán

delete from Room where id not in (select
                                      roomId from BookingDetail)
;

# Cập nhật Cột SalePrice tăng thêm 10% cho tất cả các phòng có Price >= 250000

update Room set salePrice = salePrice * 1.1 where id in (select roomId.id from (select id from Room where price >= 220000) as roomId);
;

# Yêu cầu 2 ( Sử dụng lệnh SQL tạo View )
# View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất

create view v_getRoomInfo
    as
    select * from Room
order by price desc
limit 10;

select * from v_getRoomInfo;


# View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm
# Id, BookingDate, Status, CusName, Email, Phone,TotalAmount
# ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt, = 2 Đã thanh toán, = 3 Đã hủy )
create view v_getBookingList
as
    select B.Id, B.BookingDate, case B.status
               when 0 then 'chua duyet'
               when  1 then 'da duyet'
               when  2 then 'da thanh toan'
               when  3 then 'da huy'
                   end
                as TrangThai
                   , C.name, C.Email, Phone,
                count(bd.bookingId) as Total
from Booking B
join Customer C on C.id = B.customerId
join BookingDetail BD on BD.bookingId = B.id
group by B.Id
;

select * from v_getBookingList;

# Yêu cầu 3 ( Sử dụng lệnh SQL tạo thủ tục Stored Procedure )
# Thủ tục addRoomInfo thực hiện thêm mới Room, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Room ( Trừ cột tự động tăng )
    delimiter //
    create procedure addRoomInfo(
 in name_in varchar(150),
 in status_in tinyint,
     in price_in float,
     in salePrice_in float,
     in createDate_in datetime,
     in categoryId_in int )
    begin
    insert into Room ( name, status, price, salePrice, createDate, categoryId) VALUES
(name_in,status_in,price_in,salePrice_in, createDate_in, categoryId_in);
    end;

call addRoomInfo('java pro',1,200000,170000, '2024-04-04',3);

# Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng theo Id khách hàng gồm:
# Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy),
# Khi gọi thủ tục truyền vào id cảu khách hàng
delimiter //
    create procedure getBookingByCustomerId()
    begin
        select B.Id, B.BookingDate, B.Status, count(bd.bookingId) as TotalAmount from
                                                    Booking B join BookingDetail BD on BD.bookingId = B.id
        group by B.id
        ;

    end //

    call getBookingByCustomerId();

# Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm: Id, Name, Price, SalePrice, Khi gọi thủ tuc truyền vào limit và page

delimiter //
create procedure getRoomPaginate(in pageNumber int, in size int)
    begin
        declare offset int;
        set offset = pageNumber * size;
        select * from Room
            limit size
        offset offset;

    end //

    call getRoomPaginate(0, 2);


# Tạo trigger tr_Check_Price_Value sao cho khi thêm hoặc sửa phòng Room nếu nếu giá trị của cột Price > 5000000 thì tự động chuyển về 5000000
# và in ra thông báo ‘Giá phòng lớn nhất 5 triệu’

    create trigger tr_Check_Price_Value
    before insert
    on Room
    for each row
    begin

        if new.price > 5000000
        then
            set new.price = 5000000;
            signal sqlstate '45000' set message_text = 'Giá phòng lớn nhất 5 triệu';
        end if    ;
    end ;//

    create trigger tr_Check_Price_Value
        before update
        on Room
        for each row
        begin
            if new.price > 5000000
                then
                set new.price = 5000000;
                signal sqlstate '45000' set message_text = 'Giá phòng lớn nhất 5 triệu';
            end if;
        end //
INSERT INTO Room (name, status, price, categoryId) VALUES
                                                       ('Room 18', 2, 7500000, 1);
# Tạo trigger tr_check_Room_NotAllow khi thực hiện đặt pòng, nếu ngày đến (StartDate) và ngày đi (EndDate)
# của đơn hiện tại mà phòng đã có người đặt rồi thì báo lỗi
# “Phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác”

create trigger  tr_check_Room_NotAllow
    before insert
    on BookingDetail
    for each row
    begin
        if DAY(startDate) = DAY(new.startDate) and   DAY(endDate) = DAY(new.endDate) and roomId = roomId
            then
                signal sqlstate '45000' set message_text  = 'Phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác';
        end if;
    end ;//

INSERT INTO BookingDetail (bookingId, roomId, price, startDate, endDate) VALUES
                                                                             (1, 1, 150.00, '2024-02-24', '2024-09-24');

