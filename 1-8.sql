CREATE DATABASE BOOK_STORE
GO

USE BOOK_STORE
GO

CREATE TABLE Customer (
 CustomerID int PRIMARY KEY IDENTITY,
 CustomerName varchar(50),
 Address varchar(100),
 Phone varchar(12)
 )
 GO

CREATE TABLE Book (
   BookCode int PRIMARY KEY,
   Category varchar(50),
   Author varchar(50),
   Publisher varchar(50),
   Title varchar(100),
   Price int,
   InStore int
)
GO

CREATE TABLE BookSold (
  BookSoldID int PRIMARY KEY,
  CustomerID int,
  BookCode int,
  Date datetime,
  Price int,
  Amount int,
  CONSTRAINT fk_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  CONSTRAINT fk_Book FOREIGN KEY (BookCode) REFERENCES Book(BookCode)
 )

 --1. Chèn ít nhất 5 bản ghi vào bảng Books, 5 bản ghi vào bảng Customer và 10 bản ghi vào bảng  BookSold. 
 INSERT INTO Book VALUES (111, 'Cho Dien', 'Ala', 'Ko Co', 'Viet cho nhau nghe', 12, 100),
                         (112, 'Cho Dai' ,' Alo', 'Ko Biet', 'Doc de lam giau', 50, 120),
						 (113, 'Cho Ngu', 'Ale', 'Ko Lam', 'Doc de tuong tuong', 23, 101),
						 (114, 'Cho Ngoan','Ali','Ko Ton Tai', 'Doc de an ngon', 20, 90),
						 (115, 'Cho Sua', 'Aly','Ko Choi', 'Doc de thong minh',40, 50)

INSERT INTO Customer VALUES	('Bo', 'Ha Noi', '012412412'),
                            ('Boi', 'Cao Bang', ' 12312412'),
							('Boy', 'Lang Son', '12312414'),
							('Big','Tren Troi', '3452343243'),
							('No', 'Duoi Dat', '234234234')
INSERT INTO BookSold VALUES (21, 1, 111, '1920-12-5', 15, 10),
                            (22, 2, 112, '1950-5-12', 48, 12),
							(23, 3, 113, '1940-4-2', 26, 10),
							(24, 4, 114, '1962-1-1', 18, 20),
							(25, 5, 115, '1920-1-4', 48, 29)

--2. Tạo một khung nhìn chứa danh sách các cuốn sách (BookCode, Title, Price) kèm theo số lượng đã
--bán được của mỗi cuốn sách. 

CREATE VIEW BookList AS
SELECT Book.BookCode, Title, Book.Price, Amount
FROM Book 
JOIN BookSold
ON BookSold.BookCode = Book.BookCode

--3. Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) kèm
--theo số lượng các cuốn sách mà khách hàng đó đã mua. CREATE VIEW CustomerList ASSELECT Customer.CustomerID, CustomerName, Address, BookSold.AmountFROM CustomerJOIN BookSoldOn BookSold.CustomerID = Customer.CustomerID--4.. Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) đã
--mua sách vào tháng trước, kèm theo tên các cuốn sách mà khách hàng đã mua. CREATE VIEW CustomerListago1month ASSELECT Customer.CustomerID, CustomerName, Address,Book.CategoryFROM CustomerJOIN BookSoldOn BookSold.CustomerID = Customer.CustomerID
