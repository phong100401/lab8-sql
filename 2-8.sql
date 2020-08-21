CREATE DATABASE TruongHoc
GO

USE TruongHoc
GO

CREATE TABLE Class (
  ClassCode varchar(10) PRIMARY KEY,
  HeadTeacher varchar(30),
  Room varchar(30),
  TimeSlot char,
  CloseDate datetime
)
GO


CREATE TABLE Student (
  RollNo varchar(10) PRIMARY KEY,
  ClassCode varchar(10),
  Fullname varchar(30),
  Male bit,
  BirthDate datetime,
  Address varchar(30),
  Privice char(2),
  Email varchar(30),
  CONSTRAINT fk_class FOREIGN KEY (ClassCode) REFERENCES Class(ClassCode)
 )
 GO

 DROP TABLE Student
 Go
 
 
CREATE TABLE Subject (
  SubjectCode varchar(10) PRIMARY KEY,
  SubjectName varchar(40),
  WMark bit,
  PMark bit,
  WTest_per int,
  Ptest_per int
)
GO

CREATE TABLE Mark (
 RollNo varchar(10),
 SubjectCode varchar(10),
 WMark float,
 PMark float,
 Mark float,
 CONSTRAINT pk_mark PRIMARY KEY(RollNo, SubjectCode),
 CONSTRAINT fk_Student FOREIGN KEY (RollNo) REFERENCES Student(RollNo),
 CONSTRAINT fk_Subject FOREIGN KEY (SubjectCode) REFERENCES Subject(SubjectCode)
 )
 GO


 --
 INSERT INTO Class VALUES ('T2004M','ThiDk','Class 207', 'G', '2022-1-12'),
                         ('T2004E','CTN', 'Class 208', 'K', '2021-12-4'),
						 ('T2005M', 'TrKN', 'Class 209', 'I', '2023-2-4'),
						 ('T2005E', 'AnNH', 'Class 210', 'M', '2020-5-2'),
						 ('T2006M', 'TuanTT', 'Class 211', 'N', '2021-6-2')
SELECT * FROM Class
 INSERT INTO Student values ('A1', 'T2004M', 'Nguyen Van A', 1, '1991-2-10', 'Tu Liem', 'HP', 'Nguyenvana@gmail.com'),
                             ('B1', 'T2004E', 'Nguyen Thi B', 0, '1995-5-5', 'Cau Giay', 'NB', 'Nguyenthib@gmail.com'),
							 ('C1', 'T2005M', 'Tran Xuan C', 1,'1994-4-25', 'Thanh Xuan', 'HN', 'Tranxuan@gmail.com'),
							 ('D1', 'T2005E', 'Do Van D', 0, '1997-2-5', 'Kim Ma', 'BN', 'Dovand@gmail.com'),
							 ('E1', 'T2006M', 'Pham Van Đ', 1, '1998-2-4', 'Cau Giay', 'HL', 'Phamvanđ@gmail.com')
INSERT INTO Student values ('B2', 'T2004E', 'Nguyen Van T', 1, '1994-5-4', 'Ba Tun', 'LS', 'Nguyenvant@gmail.com'),
                            ('B3', 'T2004E', 'Nguyen Van H', 1,'1996-7-5', 'Con TUm', 'DL','Nguyenvanh@gmail.com')
                           
INSERT INTO Subject VALUES ('EPC', 'Elementary', 1,1, 100,100),
                            ('CF','Control Farm', 0,1, 0, 100),
							('Java1', 'Juventu', 1,0, 10, 0),
							('Buff', 'Legend', 1,1, 10,10),
							('Math', 'Math Mogic', 1,0,10,0),
							('Economic', 'Economic of VN', 1,0,100,0)
							
INSERT INTO Mark VALUES ('A1', 'EPC', 86, 90, 88),
                        ('B1', 'CF', 70,87, 78.5),
						('C1','Java1', 78, 80, 79),
	                    ('D1','Buff', 60,65, 62.5),
						('E1', 'Economic', 79, 80, 79.5)
INSERT INTO Mark VALUES ('A1', 'CF', 79,80, 79.5),
                        ('C1','Buff', 67,80,73.5)
INSERT INTO Mark  VALUES ('B1', 'EPC', 35, 56, 45.5),
                         ('D1', 'Java1', 25, 65, 45)
SELECT * FROM Mark
--2. Tạo một khung nhìn chứa danh sách các sinh viên đã có ít nhất 2 bài thi (2 môn học khác nhau). 
CREATE VIEW List_Studen_2test as
SELECT dt.RollNo, hs.ClassCode,hs.Fullname, COUNT(*) AS N'Đã Thi ít nhất 2 môn'
FROM Student as hs
JOIN Mark as dt
ON hs.RollNo = dt.RollNo
GROUP BY dt.RollNo, hs.ClassCode, hs.Fullname
HAVING COUNT(SubjectCode)>1
--
CREATE VIEW List_Student_2test2 as
SELECT ClassCode, Fullname
FROM Student
WHERE RollNo IN (SELECT RollNo FROM Mark 
                GROUP BY RollNo
                HAVING count(SubjectCode)>1)

--3. Tạo một khung nhìn chứa danh sách tất cả các sinh viên đã bị trượt ít nhất là một môn.
CREATE VIEW Student_Exam_Faill as
SELECT ClassCode, Fullname as SV_Thi_Truot
FROM Student 
WHERE RollNo IN (SELECT RollNo FROM Mark
               WHERE Mark < 50)

--4.Tạo một khung nhìn chứa danh sách các sinh viên đang học ở TimeSlot G. 
CREATE VIEW Student_Study_TimeSlotG as
SELECT ClassCode, Fullname as SV_TimeSlotG
FROM Student
WHERE ClassCode IN (SELECT ClassCode FROM Class
                    WHERE TimeSlot= 'G')
--5. Tạo một khung nhìn chứa danh sách các giáo viên có ít nhất 3 học sinh thi trượt ở bất cứ môn nào. 
CREATE VIEW Teacher_Student_Examfaill as
SELECT HeadTeacher, Room
FROM Class 
WHERE ClassCode IN (SELECT ClassCode FROM Student_Exam_Faill
                            GROUP BY ClassCode
							HAVING count(SV_Thi_Truot)>2)
 --6. Tạo một khung nhìn chứa danh sách các sinh viên thi trượt môn EPC của từng lớp. Khung nhìn
--này phải chứa các cột: Tên sinh viên, Tên lớp, Tên Giáo viên, Điểm thi môn EPC.    
CREATE VIEW Student_ExamFaill_EPC AS
SELECT Fullname, Room, HeadTeacher, WMark, PMark, Mark
FROM Student
JOIN Class
ON Class.ClassCode = Student.ClassCode
JOIN Mark
ON Mark.RollNo = Student.RollNo
WHERE SubjectCode='EPC' AND Mark <50