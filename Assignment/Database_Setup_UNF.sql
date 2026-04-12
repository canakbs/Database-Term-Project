CREATE DATABASE IF NOT EXISTS hotel_demo DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE hotel_demo;

DROP TABLE IF EXISTS unf_table;

CREATE TABLE unf_table (
    Guest_User_ID INT, Guest_Full_Name VARCHAR(100), Guest_Email VARCHAR(100), Guest_Phone VARCHAR(20), Guest_Nationality VARCHAR(50), Guest_DOB DATE,
    Host_User_ID INT, Host_Full_Name VARCHAR(100), Host_Email VARCHAR(100), Host_Since DATE,
    Property_ID INT, Property_Title VARCHAR(100), Property_City VARCHAR(50), Property_Address TEXT,
    Room_ID INT, Room_Type VARCHAR(50), Base_Price DECIMAL(10,2),
    Booking_ID INT, CheckIn_Date DATE, CheckOut_Date DATE, Booking_Status VARCHAR(20), Is_Primary BOOLEAN,
    Method_ID INT, Card_Type VARCHAR(20), Card_Last4 CHAR(4), Expiry_Date DATE,
    Payment_ID INT, Total_Amount DECIMAL(10,2), Payment_Date DATE,
    Installment_ID INT, Due_Date DATE, Installment_Amount DECIMAL(10,2), Installment_Status VARCHAR(20),
    Service_ID INT, Service_Name VARCHAR(100), Service_Price DECIMAL(10,2), Quantity INT,
    Review_ID INT, Rating INT, Comment TEXT
);

INSERT INTO unf_table VALUES
(1,'Ahmet Yılmaz','ahmet@mail.com','555-1000','Turkish','1985-10-12', 101,'Cemil Bay','cemil@host.com','2022-01-15', 50,'Grand Bosphorus','Istanbul','Besiktas No:1', 200,'Suite',300.00, 1001,'2026-05-10','2026-05-15','Confirmed',TRUE, 10,'Visa','4321','2028-10-01', 5001,1500.00,'2026-05-10', 8001,'2026-06-10',750.00,'Pending', 1,'Breakfast',20.00,2, 9001,5,'Amazing stay!'),
(1,'Ahmet Yılmaz','ahmet@mail.com','555-1000','Turkish','1985-10-12', 101,'Cemil Bay','cemil@host.com','2022-01-15', 50,'Grand Bosphorus','Istanbul','Besiktas No:1', 200,'Suite',300.00, 1001,'2026-05-10','2026-05-15','Confirmed',TRUE, 10,'Visa','4321','2028-10-01', 5001,1500.00,'2026-05-10', 8001,'2026-06-10',750.00,'Pending', 2,'Spa',50.00,1, 9001,5,'Amazing stay!'),
(2,'Caner Öz','caner@mail.com','555-2000','Turkish','1992-04-23', 101,'Cemil Bay','cemil@host.com','2022-01-15', 50,'Grand Bosphorus','Istanbul','Besiktas No:1', 201,'Double',150.00, 1002,'2026-05-12','2026-05-16','Confirmed',TRUE, 11,'Mastercard','8765','2027-11-01', 5002,600.00,'2026-05-12', 8002,'2026-05-12',600.00,'Paid', 1,'Breakfast',20.00,2, 9002,4,'Good location.'),
(3,'Elif Şahin','elif@mail.com','555-3000','German','1990-08-30', 102,'Zeynep Kaya','zeynep@host.com','2023-05-20', 51,'Seaside Resort','Antalya','Lara No:9', 202,'Single',100.00, 1003,'2026-06-01','2026-06-05','Confirmed',TRUE, 12,'Amex','1122','2029-01-01', 5003,400.00,'2026-06-01', 8003,'2026-07-01',200.00,'Pending', 3,'Transfer',100.00,1, 9003,5,'Very relaxing.'),
(4,'Murat Aras','murat@mail.com','555-4000','Turkish','1980-02-14', 102,'Zeynep Kaya','zeynep@host.com','2023-05-20', 51,'Seaside Resort','Antalya','Lara No:9', 203,'Suite',350.00, 1004,'2026-06-10','2026-06-17','Confirmed',TRUE, 13,'Visa','9988','2028-05-01', 5004,2450.00,'2026-06-10', 8004,'2026-07-10',1225.00,'Pending', 1,'Breakfast',20.00,4, 9004,3,'Room was okay.'),
(5,'Selin Aras','selin@mail.com','555-5000','Turkish','1982-11-05', 102,'Zeynep Kaya','zeynep@host.com','2023-05-20', 51,'Seaside Resort','Antalya','Lara No:9', 203,'Suite',350.00, 1004,'2026-06-10','2026-06-17','Confirmed',FALSE, 13,'Visa','9988','2028-05-01', 5004,2450.00,'2026-06-10', 8004,'2026-07-10',1225.00,'Pending', 1,'Breakfast',20.00,4, 9004,3,'Room was okay.'),
(6,'Arda Uzun','arda@mail.com','555-6000','Turkish','1995-12-25', 103,'Bora Yılmaz','bora@host.com','2021-11-10', 52,'Mountain Lodge','Bursa','Uludag No:5', 204,'Double',200.00, 1005,'2026-01-15','2026-01-20','Cancelled',TRUE, 14,'Mastercard','5544','2027-08-01', 5005,1000.00,'2026-01-05', 8005,'2026-01-05',1000.00,'Paid', 4,'Ski Pass',50.00,2, NULL,NULL,NULL),
(7,'Kaan Yücel','kaan@mail.com','555-7000','Turkish','1998-03-12', 101,'Cemil Bay','cemil@host.com','2022-01-15', 50,'Grand Bosphorus','Istanbul','Besiktas No:1', 201,'Double',150.00, 1006,'2026-07-01','2026-07-03','Confirmed',TRUE, 15,'Visa','3333','2030-02-01', 5006,300.00,'2026-07-01', 8006,'2026-07-01',300.00,'Paid', 1,'Breakfast',20.00,2, 9005,5,'Perfect weekend.'),
(7,'Kaan Yücel','kaan@mail.com','555-7000','Turkish','1998-03-12', 101,'Cemil Bay','cemil@host.com','2022-01-15', 50,'Grand Bosphorus','Istanbul','Besiktas No:1', 201,'Double',150.00, 1006,'2026-07-01','2026-07-03','Confirmed',TRUE, 15,'Visa','3333','2030-02-01', 5006,300.00,'2026-07-01', 8006,'2026-07-01',300.00,'Paid', 5,'Laundry',25.00,1, 9005,5,'Perfect weekend.'),
(8,'Ayşe Demir','ayse@mail.com','555-8000','Turkish','1993-07-19', 102,'Zeynep Kaya','zeynep@host.com','2023-05-20', 51,'Seaside Resort','Antalya','Lara No:9', 202,'Single',100.00, 1007,'2026-08-10','2026-08-15','Confirmed',TRUE, 16,'Amex','7777','2028-12-01', 5007,500.00,'2026-08-10', 8007,'2026-08-10',500.00,'Paid', 2,'Spa',50.00,1, 9006,4,'Nice pool.'),
(8,'Ayşe Demir','ayse@mail.com','555-8000','Turkish','1993-07-19', 102,'Zeynep Kaya','zeynep@host.com','2023-05-20', 51,'Seaside Resort','Antalya','Lara No:9', 202,'Single',100.00, 1007,'2026-08-10','2026-08-15','Confirmed',TRUE, 16,'Amex','7777','2028-12-01', 5007,500.00,'2026-08-10', 8007,'2026-08-10',500.00,'Paid', 3,'Transfer',100.00,1, 9006,4,'Nice pool.');

SELECT * FROM unf_table;
