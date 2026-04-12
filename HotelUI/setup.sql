DROP DATABASE IF EXISTS hotel_management;
CREATE DATABASE hotel_management DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE hotel_management;

CREATE TABLE USERS (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Password_Hash VARCHAR(255),
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE HOSTS (
    Host_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Host_Since DATE,
    FOREIGN KEY (User_ID) REFERENCES USERS(User_ID)
);

CREATE TABLE GUESTS (
    Guest_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Nationality VARCHAR(50),
    Date_of_Birth DATE,
    FOREIGN KEY (User_ID) REFERENCES USERS(User_ID)
);

CREATE TABLE PROPERTIES (
    Property_ID INT PRIMARY KEY AUTO_INCREMENT,
    Host_ID INT NOT NULL,
    Title VARCHAR(100),
    City VARCHAR(50),
    Address TEXT,
    FOREIGN KEY (Host_ID) REFERENCES HOSTS(Host_ID)
);

CREATE TABLE ROOMS (
    Room_ID INT PRIMARY KEY AUTO_INCREMENT,
    Property_ID INT NOT NULL,
    Room_Type VARCHAR(50),
    Base_Price DECIMAL(10,2),
    FOREIGN KEY (Property_ID) REFERENCES PROPERTIES(Property_ID)
);

CREATE TABLE BOOKINGS (
    Booking_ID INT PRIMARY KEY AUTO_INCREMENT,
    Room_ID INT NOT NULL,
    CheckIn_Date DATE,
    CheckOut_Date DATE,
    Status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (Room_ID) REFERENCES ROOMS(Room_ID)
);

CREATE TABLE BOOKING_DETAILS (
    Booking_ID INT NOT NULL,
    Guest_ID INT NOT NULL,
    Is_Primary BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (Booking_ID, Guest_ID),
    FOREIGN KEY (Booking_ID) REFERENCES BOOKINGS(Booking_ID) ON DELETE CASCADE,
    FOREIGN KEY (Guest_ID) REFERENCES GUESTS(Guest_ID)
);

CREATE TABLE PAYMENT_METHODS (
    Method_ID INT PRIMARY KEY AUTO_INCREMENT,
    Guest_ID INT NOT NULL,
    Card_Type VARCHAR(20),
    Card_Last4 CHAR(4),
    Expiry_Date DATE,
    FOREIGN KEY (Guest_ID) REFERENCES GUESTS(Guest_ID)
);

CREATE TABLE PAYMENTS (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Booking_ID INT NOT NULL,
    Method_ID INT,
    Total_Amount DECIMAL(10,2),
    Payment_Date DATE,
    FOREIGN KEY (Booking_ID) REFERENCES BOOKINGS(Booking_ID) ON DELETE CASCADE,
    FOREIGN KEY (Method_ID) REFERENCES PAYMENT_METHODS(Method_ID)
);

CREATE TABLE INSTALLMENTS (
    Installment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Payment_ID INT NOT NULL,
    Due_Date DATE,
    Amount DECIMAL(10,2),
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (Payment_ID) REFERENCES PAYMENTS(Payment_ID) ON DELETE CASCADE
);

CREATE TABLE SERVICES (
    Service_ID INT PRIMARY KEY AUTO_INCREMENT,
    Service_Name VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE BOOKING_SERVICES (
    Booking_ID INT NOT NULL,
    Service_ID INT NOT NULL,
    Quantity INT DEFAULT 1,
    PRIMARY KEY (Booking_ID, Service_ID),
    FOREIGN KEY (Booking_ID) REFERENCES BOOKINGS(Booking_ID) ON DELETE CASCADE,
    FOREIGN KEY (Service_ID) REFERENCES SERVICES(Service_ID)
);

CREATE TABLE REVIEWS (
    Review_ID INT PRIMARY KEY AUTO_INCREMENT,
    Booking_ID INT NOT NULL,
    Guest_ID INT NOT NULL,
    Rating INT,
    Comment TEXT,
    FOREIGN KEY (Booking_ID) REFERENCES BOOKINGS(Booking_ID) ON DELETE CASCADE,
    FOREIGN KEY (Guest_ID) REFERENCES GUESTS(Guest_ID)
);

-- SAMPLE DATA

INSERT INTO USERS VALUES
(1,'Ahmet Yılmaz','ahmet@grandplaza.com','555-1001',NULL,'2024-01-10'),
(2,'Caner Öz','caner@seaside.com','555-2002',NULL,'2023-11-05'),
(3,'Mehmet Demir','mehmet@mail.com','555-3003',NULL,'2025-05-15'),
(4,'Elif Şahin','elif@mail.com','555-4004',NULL,'2025-07-20'),
(5,'Murat Aras','murat@mail.com','555-5005',NULL,'2025-01-30'),
(6,'Selin Aras','selin@mail.com','555-6006',NULL,'2025-01-30'),
(7,'Zeynep Yıldız','zeynep@mail.com','555-7007',NULL,'2025-09-12'),
(8,'Arda Uzun','arda@mail.com','555-8008',NULL,'2025-11-03');

INSERT INTO HOSTS VALUES (1,1,'2024-01-10'),(2,2,'2023-11-05');

INSERT INTO GUESTS VALUES
(1,3,'Turkish','1990-06-01'),(2,4,'German','1988-09-12'),
(3,5,'Turkish','1995-03-22'),(4,6,'Turkish','1997-07-15'),
(5,7,'Turkish','1992-11-30'),(6,8,'Turkish','1998-04-25');

INSERT INTO PROPERTIES VALUES
(1,1,'Grand Plaza','Istanbul','Besiktas Mah. No:5'),
(2,2,'Seaside Resort','Antalya','Kemer Sahil Yolu No:1');

INSERT INTO ROOMS VALUES
(1,1,'Single',100.00),(2,1,'Double',150.00),(3,1,'Suite',300.00),
(4,2,'Double',200.00),(5,2,'Suite',350.00);

INSERT INTO BOOKINGS VALUES
(101,1,'2026-03-20','2026-03-22','Confirmed'),
(102,2,'2026-03-21','2026-03-25','Confirmed'),
(103,5,'2026-04-10','2026-04-17','Confirmed'),
(104,4,'2026-04-12','2026-04-15','Confirmed'),
(105,3,'2026-04-20','2026-04-23','Confirmed');

INSERT INTO BOOKING_DETAILS VALUES
(101,1,TRUE),(102,2,TRUE),(103,3,TRUE),
(103,4,FALSE),(104,5,TRUE),(105,6,TRUE);

INSERT INTO PAYMENT_METHODS VALUES
(1,1,'Visa','1234','2028-06-01'),(2,2,'Mastercard','5678','2027-12-01'),
(3,3,'Amex','9012','2029-03-01'),(4,5,'Visa','3456','2027-09-01'),
(5,6,'Visa','7890','2028-11-01');

INSERT INTO PAYMENTS VALUES
(201,101,1,250.00,'2026-03-20'),(202,102,2,600.00,'2026-03-21'),
(203,103,3,2450.00,'2026-04-10'),(204,104,4,600.00,'2026-04-12'),
(205,105,5,950.00,'2026-04-20');

INSERT INTO INSTALLMENTS VALUES
(301,201,'2026-04-20',125.00,'Pending'),(302,201,'2026-05-20',125.00,'Pending'),
(303,202,'2026-04-21',300.00,'Pending'),(304,202,'2026-05-21',300.00,'Pending'),
(305,203,'2026-05-10',816.67,'Pending'),(306,203,'2026-06-10',816.67,'Pending'),
(307,203,'2026-07-10',816.66,'Pending');

INSERT INTO SERVICES VALUES
(1,'Breakfast',20.00),(2,'Spa',50.00),(3,'Airport Transfer',100.00),
(4,'Room Service',35.00),(5,'Laundry',25.00);

INSERT INTO BOOKING_SERVICES VALUES
(101,1,2),(102,2,2),(103,3,1),(103,1,4),(104,1,1),(105,2,1),(105,4,2);

INSERT INTO REVIEWS VALUES
(401,101,1,5,'Amazing stay! Very clean and comfortable.'),
(402,102,2,4,'Great service, highly recommended.'),
(403,103,3,5,'Perfect holiday, the suite was breathtaking.'),
(404,104,5,3,'Average experience, room was a bit small.'),
(405,105,6,4,'Nice rooms, good location.');

-- === ADDITIONAL DATA TO POPULATE UI ===

INSERT INTO USERS VALUES
(9,'Hasan Yılmaz','hasan@mail.com','555-9009',NULL,'2025-12-01'),
(10,'Ayşe Kaya','ayse@mail.com','555-1010',NULL,'2025-11-22'),
(11,'Fatma Demir','fatma@mail.com','555-1111',NULL,'2026-01-15'),
(12,'Ali Çelik','ali@mail.com','555-1212',NULL,'2026-02-05'),
(13,'Kemal Sunal','kemal@mail.com','555-1313',NULL,'2026-01-10'),
(14,'Ece Seçkin','ece@mail.com','555-1414',NULL,'2026-03-01'),
(15,'Burak Özçivit','burak@mail.com','555-1515',NULL,'2026-03-05');

INSERT INTO HOSTS VALUES (3,9,'2025-12-01');

INSERT INTO GUESTS VALUES
(7,10,'Turkish','1985-04-12'),(8,11,'Turkish','1992-08-30'),
(9,12,'Turkish','1990-05-18'),(10,13,'Turkish','1988-11-11'),
(11,14,'Turkish','1996-02-14'),(12,15,'Turkish','1984-12-24');

INSERT INTO PROPERTIES VALUES
(3,3,'City Center Hotel','Izmir','Alsancak Mah. No:10'),
(4,3,'Ankara Business Inn','Ankara','Cankaya Mah. No:45');

INSERT INTO ROOMS VALUES
(6,3,'Single',120.00),(7,3,'Double',180.00),(8,3,'Suite',400.00),
(9,4,'Single',110.00),(10,4,'Suite',320.00);

INSERT INTO BOOKINGS VALUES
(106,6,'2026-05-01','2026-05-05','Confirmed'),
(107,7,'2026-05-10','2026-05-12','Confirmed'),
(108,8,'2026-05-15','2026-05-20','Confirmed'),
(109,9,'2026-06-01','2026-06-05','Confirmed'),
(110,10,'2026-06-10','2026-06-15','Confirmed'),
(111,1,'2026-07-01','2026-07-05','Confirmed'),
(112,2,'2026-07-10','2026-07-15','Confirmed'),
(113,3,'2026-08-01','2026-08-10','Confirmed'),
(114,4,'2026-08-15','2026-08-20','Confirmed'),
(115,5,'2026-09-01','2026-09-05','Confirmed');

INSERT INTO BOOKING_DETAILS VALUES
(106,7,TRUE),(107,8,TRUE),(108,9,TRUE),(109,10,TRUE),(110,11,TRUE),
(111,12,TRUE),(112,7,TRUE),(113,8,TRUE),(114,9,TRUE),(115,10,TRUE);

INSERT INTO PAYMENT_METHODS VALUES
(6,7,'Visa','1111','2028-10-01'),(7,8,'Mastercard','2222','2029-11-01'),
(8,9,'Amex','3333','2028-12-01'),(9,10,'Visa','4444','2030-01-01'),
(10,11,'Mastercard','5555','2029-05-01');

INSERT INTO PAYMENTS VALUES
(206,106,6,480.00,'2026-05-01'),(207,107,7,360.00,'2026-05-10'),
(208,108,8,2000.00,'2026-05-15'),(209,109,9,440.00,'2026-06-01'),
(210,110,10,1600.00,'2026-06-10'),
(211,111,6,500.00,'2026-07-01'),(212,112,7,750.00,'2026-07-10'),
(213,113,8,3000.00,'2026-08-01'),(214,114,9,1000.00,'2026-08-15'),
(215,115,10,1750.00,'2026-09-01');

INSERT INTO BOOKING_SERVICES VALUES
(106,1,2),(107,2,1),(108,3,2),(109,1,1),(110,2,2),(111,3,1),(112,1,2);

INSERT INTO REVIEWS VALUES
(406,106,7,5,'Great location and nice rooms.'),
(407,107,8,4,'Very good service.'),
(408,108,9,5,'The suite was absolutely gorgeous.'),
(409,109,10,3,'Okay stay, but the AC was loud.'),
(410,110,11,4,'Beautiful property, will come back.');

-- === VIEWS FOR UNF RECONSTRUCTION ===

CREATE OR REPLACE VIEW confirmationUsingJoins AS 
SELECT 
    g.Guest_ID, ug.Full_Name AS Guest_Name, ug.Email AS Guest_Email,
    h.Host_ID, uh.Full_Name AS Host_Name, h.Host_Since,
    p.Property_ID, p.Title, p.City,
    r.Room_ID, r.Room_Type, r.Base_Price,
    b.Booking_ID, b.CheckIn_Date, b.CheckOut_Date, b.Status,
    bd.Is_Primary,
    pm.Method_ID, pm.Card_Type, pm.Card_Last4,
    pay.Payment_ID, pay.Total_Amount, pay.Payment_Date,
    ins.Installment_ID, ins.Due_Date, ins.Amount, ins.Status AS Inst_Status,
    s.Service_ID, s.Service_Name, bs.Quantity,
    rev.Review_ID, rev.Rating, rev.Comment
FROM GUESTS g
JOIN USERS ug ON ug.User_ID = g.User_ID
JOIN BOOKING_DETAILS bd ON bd.Guest_ID = g.Guest_ID
JOIN BOOKINGS b ON b.Booking_ID = bd.Booking_ID
JOIN ROOMS r ON r.Room_ID = b.Room_ID
JOIN PROPERTIES p ON p.Property_ID = r.Property_ID
JOIN HOSTS h ON h.Host_ID = p.Host_ID
JOIN USERS uh ON uh.User_ID = h.User_ID
LEFT JOIN PAYMENT_METHODS pm ON pm.Guest_ID = g.Guest_ID
LEFT JOIN PAYMENTS pay ON pay.Booking_ID = b.Booking_ID
LEFT JOIN INSTALLMENTS ins ON ins.Payment_ID = pay.Payment_ID
LEFT JOIN BOOKING_SERVICES bs ON bs.Booking_ID = b.Booking_ID
LEFT JOIN SERVICES s ON s.Service_ID = bs.Service_ID
LEFT JOIN REVIEWS rev ON rev.Booking_ID = b.Booking_ID AND rev.Guest_ID = g.Guest_ID;
