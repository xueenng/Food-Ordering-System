/*
COURSE CODE: UCCD2303
PROGRAMME (IA/IB/CS)/DE: CS
GROUP NUMBER e.g. G001: G028
GROUP LEADER NAME & EMAIL: Wong Sin Yew janesinyew@1utar.my
MEMBER 2 NAME: Chang Joo Yee
MEMBER 3 NAME: Ng Xue En
MEMBER 4 NAME: Wong Xin Tong
Submission date and time (DD-MON-YY):

GROUP ASSIGNMENT SUBMISSION
Submit one individual report ith SQL statements only (*.docx)
and one sql script (*.sql for Oracle)

Template save as "G999.sql"  e.g. G001.sql
Part 1 script only.
Refer to the format of Northwoods.sql as an example for group sql script submission

Your GROUP member information should appear in both files one individual report docx & one individual sql script, 
then save as G01.zip


*/


DROP TABLE PERSON CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE MANAGER CASCADE CONSTRAINTS;
DROP TABLE CONTRACT_EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE PARTTIME_EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE CUSTOMER CASCADE CONSTRAINTS;
DROP TABLE MEMBER CASCADE CONSTRAINTS;
DROP TABLE GUEST CASCADE CONSTRAINTS;
DROP TABLE MEMBERSHIP_LEVEL CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE ORDER_S CASCADE CONSTRAINTS;
DROP TABLE ORDER_ITEM CASCADE CONSTRAINTS;
DROP TABLE FOODITEM CASCADE CONSTRAINTS;
DROP TABLE FOOD_CATEGORY CASCADE CONSTRAINTS;


--Create Tables

CREATE TABLE PERSON 
(
    personID 	CHAR(4) PRIMARY KEY,
    firstName 	VARCHAR2(20),
    lastName 	VARCHAR2(20),
    phoneNo 	VARCHAR2(12),
    personDOB 	DATE,
    Gender 	CHAR(1),
    personType 	VARCHAR2(20),
    CONSTRAINT CHK_PERSON_gender CHECK (Gender='M' or Gender='F')
);

CREATE TABLE EMPLOYEE 
(
    personID	CHAR(4) PRIMARY KEY,
    totalSalary	NUMBER(10,2)DEFAULT 0,
    empType	VARCHAR2(30),
    CONSTRAINT CHK_empType CHECK (empType='Contract Employee' or empType='Part-time Employee'or empType='Manager')
);

CREATE TABLE MANAGER 
(
    mgrID	CHAR(4) PRIMARY KEY,
    carAllowance	NUMBER(10,2) DEFAULT 0,
    housingAllowance	NUMBER(10,2)DEFAULT 0,
    mgrRole 	VARCHAR2(50)
);

CREATE TABLE CONTRACT_EMPLOYEE 
(
    personID	CHAR(4) PRIMARY KEY,
    monthyIncentives	NUMBER(10,2)DEFAULT 0,
    contractStartDate	DATE,
    contractEndDate	DATE,
    mgrID CHAR(4),
    FOREIGN KEY(mgrID) REFERENCES MANAGER(mgrID)
);

CREATE TABLE PARTTIME_EMPLOYEE 
(
    personID	CHAR(4) PRIMARY KEY,
    hoursRate	NUMBER(10,2) DEFAULT 0,
    weeklyWorkHrs	NUMBER(7) DEFAULT 0,
    mgrID CHAR(4),
    FOREIGN KEY(mgrID) REFERENCES MANAGER(mgrID)
);

CREATE TABLE CUSTOMER 
(
    personID	CHAR(4) PRIMARY KEY,
    Email	VARCHAR2(100),
    cusType	VARCHAR2(15),
    CONSTRAINT CHK_cusType CHECK(cusType='Guest' or cusType ='Member')
);

CREATE TABLE MEMBERSHIP_LEVEL 
(
    membershipLevelID	CHAR(5) PRIMARY KEY,
    membershipName	VARCHAR2(20),
    discountRate	NUMBER(4,2)
);

CREATE TABLE MEMBER 
(
    personID	CHAR(4),
    membershipLevelID	CHAR(5),
    startDate	DATE,
    endDate	 DATE,
    FOREIGN KEY (personID) REFERENCES PERSON(personID),
    FOREIGN KEY (membershipLevelID) REFERENCES MEMBERSHIP_LEVEL(membershipLevelID)
);


CREATE TABLE GUEST 
(
    personID	CHAR(4) PRIMARY KEY,
    visitDate	DATE
);

CREATE TABLE ORDER_S
(
    orderID 	CHAR(5) PRIMARY KEY,
    cusID 	CHAR(4),
    empID 	CHAR(4),
    OrderType 	VARCHAR2(20),
    orderDate 	DATE,
    totalAmount 	NUMBER(10,2)NOT NULL,
    Discount 	NUMBER(4,2),
    FOREIGN KEY(cusID) REFERENCES CUSTOMER(personID),
    FOREIGN KEY(empID) REFERENCES EMPLOYEE(personID)
);

CREATE TABLE PAYMENT 
(
    pID	CHAR(4) PRIMARY KEY,
    orderID	CHAR(5),
    cusID	    CHAR(4),
    payDate	DATE,
    payAmount	NUMBER(10,2)DEFAULT 0,
    payMethod	VARCHAR2(40),
    FOREIGN KEY(orderID) REFERENCES ORDER_S(orderID),
    FOREIGN KEY(cusID) REFERENCES CUSTOMER(personID),
    CONSTRAINT CHK_payMethod CHECK(payMethod='Debit Card' or payMethod='Credit Card' or payMethod='E-Wallet')
);

CREATE TABLE FOOD_CATEGORY 
(
    foodCategoryID	CHAR(4) PRIMARY KEY,
    foodCategoryName	VARCHAR2(20),
    itemNo	NUMBER(10)DEFAULT 0
);


CREATE TABLE FOODITEM 
(
    itemID	CHAR(4) PRIMARY KEY,
    foodCategoryID	CHAR(4) ,
    foodName	VARCHAR2(30),
    foodUnitPrice	NUMBER(6,2)DEFAULT 0,
    fQuatity	NUMBER(7)DEFAULT 0,
    FOREIGN KEY(foodCategoryID) REFERENCES FOOD_CATEGORY(foodCategoryID)
);

CREATE TABLE ORDER_ITEM 
(
    orderID	CHAR(5),
    itemID	CHAR(4),
    orderQuantity	NUMBER(7)NOT NULL,
    orderPrice	NUMBER(6,2)DEFAULT 0,
    FOREIGN KEY (orderID) REFERENCES ORDER_S(orderID),
    FOREIGN KEY (itemID) REFERENCES FOODITEM(itemID)
);


---create role/user and grant privilege

DROP ROLE c##Manager_Role;
DROP ROLE c##General_Manager_Role;
DROP ROLE c##Contract_Employee;

CREATE ROLE c##Contract_Employee;
CREATE ROLE c##Manager_Role;
CREATE ROLE c##General_Manager_Role;


GRANT CREATE SESSION TO c##Contract_Employee;
GRANT CREATE SESSION, CREATE TABLE TO c##Manager_Role;
GRANT CREATE SESSION, CREATE TABLE TO c##General_Manager_Role;



GRANT SELECT ON PAYMENT TO c##Contract_Employee;
GRANT SELECT ON ORDER_S TO c##Contract_Employee;
GRANT SELECT ON ORDER_ITEM TO c##Contract_Employee;



GRANT SELECT ON PERSON TO c##Manager_Role;
GRANT SELECT ON EMPLOYEE TO c##Manager_Role;

GRANT SELECT, INSERT, UPDATE, DELETE ON CONTRACT_EMPLOYEE TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON PARTTIME_EMPLOYEE TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON CUSTOMER TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON MEMBER TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON GUEST TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON MEMBERSHIP_LEVEL  TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON PAYMENT TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_S TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_ITEM TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FOODITEM TO c##Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FOOD_CATEGORY TO c##Manager_Role;

GRANT SELECT, INSERT, UPDATE, DELETE ON PERSON TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON EMPLOYEE TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON CONTRACT_EMPLOYEE TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON PARTTIME_EMPLOYEE TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON CUSTOMER TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON MEMBER TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON GUEST TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON MEMBERSHIP_LEVEL  TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON PAYMENT TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_S TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_ITEM TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FOODITEM TO c##General_Manager_Role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FOOD_CATEGORY TO c##General_Manager_Role;

DROP USER c##JasmineLee;
CREATE USER c##JasmineLee
IDENTIFIED BY E001;
GRANT c##General_Manager_Role TO c##JasmineLee;


--Insert record into Person Table

INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E001', 'Jasmine', 'Lee', '012-3456789', '3-Jan-1985', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E002', 'Ahmad', 'Hassan', '013-4567890', '15-Mar-1992', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E003', 'Emily', 'Wong', '011-23456789', '28-Jun-1978', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E004', 'Rajesh', 'Patel', '019-3456789', '9-Sep-1983', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E005', 'Fatimah', 'Abdullah', '014-4567890', '22-Nov-1990', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E006', 'Michael', 'Johnson', '010-5678901', '7-Apr-1987', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E007', 'Priya', 'Gupta', '011-67890123', '19-Jul-1975', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E008', 'David', 'Lim', '017-7890123', '31-Oct-1980', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E009', 'Mei Ling', 'Tan', '016-8901234', '12-Dec-1989', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E010', 'Muhammad', 'Ali', '019-9012345', '25-Feb-1984', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E011', 'Sofia', 'Rodriguez', '013-0123456', '8-May-1995', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E012', 'Anand', 'Krishnan', '011-12345678', '21-Aug-1972', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E013', 'Anna', 'Smith', '010-23456789', '3-Nov-1986', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E014', 'Hadi', 'Zainal', '015-34567890', '16-Feb-1993', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E015', 'Maria', 'Garcia', '019-45678901', '31-May-1980', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E016', 'Yusuf', 'Khan', '012-56789012', '13-Aug-1977', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E017', 'Grace', 'Ng', '014-67890123', '26-Oct-1991', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E018', 'Siti', 'Aisyah', '018-78901234', '9-Dec-1988', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E019', 'Daniel', 'Ong', '011-89012345', '24-Mar-1974', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E020', 'Sarah', 'Chen', '010-90123456', '6-Jun-1981', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E021', 'Olivia', 'Wilson', '013-01234567', '19-Sep-1996', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E022', 'Ethan', 'Thompson', '017-12345678', '2-Dec-1982', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E023', 'Ava', 'Garcia', '011-23456789', '15-Apr-1979', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E024', 'Liam', 'Martinez', '019-34567890', '28-Jul-1994', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E025', 'Isabella', 'Robinson', '015-45678901', '11-Oct-1976', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E026', 'Lucas', 'Clark', '012-56789012', '24-Jan-1998', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E027', 'Mia', 'Rodriguez', '016-67890123', '8-Apr-1985', 'F', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('E028', 'Noah', 'Lewis', '010-78901234', '21-Jul-1973', 'M', 'Employee');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C001', 'Thomas', 'Wong', '012-3366729', '2-Oct-1998', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C002', 'Mary', 'Tan', '011-3126673', '19-May-2002', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C003', 'Sally', 'Cheng', '013-1369731', '7-Feb-1970', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C004', 'Lay', 'Zhang', '010-6566032', '23-Jul-1982', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C005', 'Ah Meng', 'Hu', '018-1266730', '10-Nov-1979', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C006', 'John', 'Lee', '012-9829166', '25-Jan-1999', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C007', 'David', 'Yee', '011-3231903', '13-May-2001', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C008', 'Jay', 'Park', '012-3129101', '29-Apr-1987', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C009', 'Xue Ling', 'Song', '016-1219312', '5-Jun-1992', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C010', 'Wilson', 'Loo', '013-2190023', '18-Dec-1990', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C011', 'Tong Yew', 'Chan', '011-0912111', '20-Aug-1996', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C012', 'Dorris', 'Oh', '010-3366740', '6-Nov-1983', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C013', 'Jackson', 'Wang', '016-1299023', '27-Mar-1984', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C014', 'Mei Mei', 'Ong', '017-8734222', '21-Jul-1988', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C015', 'Han Pi', 'Kee', '013-2811235', '15-Sep-1971', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C016', 'Mei Yee', 'Liang', '012-3128370', '21-Jul-1989', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C017', 'Alica', 'Foo', '010-5027833', '13-Dec-1979', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C018', 'Tom', 'Ng', '018-3865212', '21-Aug-1993', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C019', 'Mi', 'Yang', '011-6301238', '15-Feb-1992', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C020', 'Chloe', 'Wong', '017-9283948', '1-Sep-1989', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C021', 'Ka Ho', 'Hung', '012-3881210', '15-Sep-1995', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C022', 'Zoey', 'Low', '010-9188149', '5-Mar-1996', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C023', 'Jane', 'Tse', '013-4432607', '19-Jul-1975', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C024', 'Song Poh', 'Chin', '014-5629013', '21-Jun-1985', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C025', 'Mi Mi', 'Lim', '012-9192551', '14-Oct-1992', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C026', 'An An', 'Goh', '016-5670135', '12-Apr-1971', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C027', 'Wei Ping', 'Cheng', '018-7782701', '15-Sep-1979', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C028', 'Ki Bum', 'Kim', '011-3290454', '22-May-1983', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C029', 'Minnie', 'An', '017-2289127', '12-Nov-1991', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C030', 'Min Ho', 'Choi', '010-5382336', '26-Dec-1976', 'M', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C031', 'Krystal', 'Jung', '012-9712473', '3-Aug-1982', 'F', 'Customer');
INSERT INTO PERSON (personID, firstName, lastName, phoneNo, personDOB, Gender, personType) VALUES ('C032', 'Shu Hua', 'Yeh', '013-1128395', '6-Jan-2000', 'F', 'Customer');


--Insert record into Employee Table

INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E001', '4000.00', 'Manager');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E002', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E003', '1600.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E004', '4000.00', 'Manager');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E005', '1824.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E006', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E007', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E008', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E009', '960.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E010', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E011', '1600.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E012', '4000.00', 'Manager');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E013', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E014', '1600.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E015', '4000.00', 'Manager');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E016', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E017', '2640.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E018', '1216.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E019', '4000.00', 'Manager');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E020', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E021', '1680.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E022', '4000.00', 'Manager');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E023', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E024', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E025', '1260.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E026', '2500.00', 'Contract Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E027', '2016.00', 'Part-time Employee');
INSERT INTO EMPLOYEE (personID, totalSalary, empType) VALUES ('E028', '2500.00', 'Contract Employee');


--Insert Record into Manager Table

INSERT INTO MANAGER (mgrID, carAllowance, housingAllowance, mgrRole) VALUES ('E001', '1000.00', '1500.00', 'General Manager');
INSERT INTO MANAGER (mgrID, carAllowance, housingAllowance, mgrRole) VALUES ('E004', '1200.00', '1800.00', 'Assistant Manager');
INSERT INTO MANAGER (mgrID, carAllowance, housingAllowance, mgrRole) VALUES ('E012', '900.00', '2000.00', 'Shift Manager');
INSERT INTO MANAGER (mgrID, carAllowance, housingAllowance, mgrRole) VALUES ('E015', '1100.00', '1700.00', 'Kitchen Manager');
INSERT INTO MANAGER (mgrID, carAllowance, housingAllowance, mgrRole) VALUES ('E019', '1300.00', '1900.00', 'Bar Manager');
INSERT INTO MANAGER (mgrID, carAllowance, housingAllowance, mgrRole) VALUES ('E022', '950.00', '1600.00', 'Floor Manager');


--Insert record into Contract_Employee Table

INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E002', '100.00', '1-May-2023', '7-May-2023', 'E001');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E006', '80.00', '2-Oct-2023', '8-Oct-2023', 'E022');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E007', '50.00', '15-Mar-2023', '15-Sep-2023', 'E019');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E008', '75.00', '20-Apr-2023', '20-Oct-2023', 'E012');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E010', '200.00', '25-May-2023', '25-Nov-2023', 'E015');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E013', '150.00', '30-Jun-2023', '30-Dec-2023', 'E001');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E016', '125.00', '7-May-2024', '1-May-2025', 'E001');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E020', '80.00', '8-Oct-2024', '2-Oct-2025', 'E019');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E023', '120.00', '15-Sep-2024', '15-Mar-2025', 'E015');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E024', '175.00', '20-Oct-2024', '20-Apr-2025', 'E015');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E026', '90.00', '25-Nov-2024', '25-May-2025', 'E022');
INSERT INTO CONTRACT_EMPLOYEE (personID, monthyIncentives, contractStartDate, contractEndDate, mgrID) VALUES ('E028', '150.00', '30-Dec-2024', '30-Jun-2025', 'E015');


--Insert record into Parttime_Employee Table

INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E003', '10.00', '40', 'E004');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E005', '12.00', '38', 'E015');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E009', '8.00', '30', 'E022');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E011', '10.00', '40', 'E019');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E014', '10.00', '40', 'E019');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E017', '15.00', '44', 'E015');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E018', '8.00', '38', 'E001');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E021', '10.00', '42', 'E004');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E025', '9.00', '35', 'E001');
INSERT INTO PARTTIME_EMPLOYEE (personID, hoursRate, weeklyWorkHrs, mgrID) VALUES ('E027', '12.00', '42', 'E004');


--Insert record into Customer Table

INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C001', 'thomas12@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C002', 'mary32@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C003', 'sallycheng@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C004', 'layzhang@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C005', 'ahmeng812@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C006', 'johnlee@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C007', 'david232@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C008', 'jaypark@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C009', 'xueling90@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C010', 'wilsonloo@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C011', 'tychan01@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C012', 'dorrischan@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C013', 'jackson8129@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C014', 'meimei88@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C015', 'hanpi@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C016', 'meiyee55@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C017', 'alicafoo@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C018', 'tomng20@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C019', 'yangmi@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C020', 'chloewong@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C021', 'kaho@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C022', 'zoeylow@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C023', 'janetse34@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C024', 'spchin85@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C025', 'mimilam@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C026', 'anangoh@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C027', 'weiping@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C028', 'kibum@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C029', 'minnie12@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C030', 'minho@gmail.com', 'Member');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C031', 'krystal02@gmail.com', 'Guest');
INSERT INTO CUSTOMER (personID, Email, cusType) VALUES ('C032', 'shuhua@gmail.com', 'Member');


--Insert record into Membership_Level Table

INSERT INTO MEMBERSHIP_LEVEL (membershipLevelID, membershipName, discountRate) VALUES ('ML001', 'Basic', '0.05');
INSERT INTO MEMBERSHIP_LEVEL (membershipLevelID, membershipName, discountRate) VALUES ('ML002', 'Bronze', '0.08');
INSERT INTO MEMBERSHIP_LEVEL (membershipLevelID, membershipName, discountRate) VALUES ('ML003', 'Silver', '0.1');
INSERT INTO MEMBERSHIP_LEVEL (membershipLevelID, membershipName, discountRate) VALUES ('ML004', 'Gold', '0.15');
INSERT INTO MEMBERSHIP_LEVEL (membershipLevelID, membershipName, discountRate) VALUES ('ML005', 'Platinum', '0.2');


--Insert record into Member Table

INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C003', 'ML001', '5-Feb-2023', '5-Feb-2024');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C005', 'ML003', '24-Mar-2022', '24-Mar-2025');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C008', 'ML005', '25-Apr-2023', '25-Apr-2028');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C011', 'ML001', '9-Jun-2023', '9-Jun-2024');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C013', 'ML002', '12-Dec-2022', '12-Dec-2024');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C015', 'ML001', '8-Jul-2023', '8-Jul-2024');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C017', 'ML003', '1-Jan-2024', '1-Jan-2027');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C018', 'ML004', '15-Oct-2022', '15-Oct-2026');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C021', 'ML001', '2-Feb-2024', '2-Feb-2025');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C023', 'ML002', '13-May-2022', '13-May-2024');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C026', 'ML001', '6-Jan-2023', '6-Jan-2024');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C028', 'ML004', '7-Mar-2022', '7-Mar-2026');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C030', 'ML005', '29-Aug-2023', '29-Aug-2028');
INSERT INTO MEMBER (personID, membershipLevelID, startDate, endDate) VALUES ('C032', 'ML003', '2-Jan-2022', '2-Jan-2025');


--Insert record into Guest Table

INSERT INTO GUEST (personID, visitDate) VALUES ('C001', '4-Jan-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C002', '4-Jan-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C004', '4-Feb-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C006', '4-Feb-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C007', '4-Feb-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C009', '4-Mar-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C010', '4-Mar-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C012', '4-Apr-3024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C014', '4-May-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C016', '4-May-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C019', '4-Jun-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C020', '4-Jun-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C022', '4-Jul-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C024', '4-Jul-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C025', '4-Aug-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C027', '4-Aug-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C029', '4-Sep-2024');
INSERT INTO GUEST (personID, visitDate) VALUES ('C031', '4-Sep-2024');


--Insert record into Order_S Table

INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR001', 'C001', 'E003', 'Dine-In', '1-Apr-2024', '37.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR002', 'C002', 'E005', 'Take Away', '1-Apr-2024', '26.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR003', 'C003', 'E009', 'Dine-In', '1-Apr-2024', '14.00', '0.70');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR004', 'C004', 'E011', 'Take Away', '2-Apr-2024', '11.50', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR005', 'C005', 'E014', 'Dine-In', '2-Apr-2024', '15.00', '1.50');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR006', 'C006', 'E017', 'Take Away', '2-Apr-2024', '21.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR007', 'C007', 'E018', 'Take Away', '2-Apr-2024', '20.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR008', 'C008', 'E021', 'Dine-In', '3-Apr-2024', '15.00', '3.00');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR009', 'C009', 'E025', 'Take Away', '3-Apr-2024', '26.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR010', 'C010', 'E027', 'Dine-In', '3-Apr-2024', '17.50', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR011', 'C011', 'E001', 'Take Away', '4-Apr-2024', '7.50', '0.40');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR012', 'C012', 'E004', 'Dine-In', '4-Apr-2024', '13.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR013', 'C013', 'E012', 'Dine-In', '5-Apr-2024', '60.00', '4.80');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR014', 'C014', 'E015', 'Take Away', '5-Apr-2024', '15.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR015', 'C015', 'E019', 'Dine-In', '5-Apr-2024', '18.00', '0.90');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR016', 'C016', 'E022', 'Take Away', '5-Apr-2024', '62.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR017', 'C017', 'E003', 'Dine-In', '6-Apr-2024', '32.00', '3.20');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR018', 'C018', 'E005', 'Take Away', '6-Apr-2024', '24.00', '3.60');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR019', 'C019', 'E009', 'Dine-In', '6-Apr-2024', '27.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR020', 'C020', 'E011', 'Dine-In', '6-Apr-2024', '20.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR021', 'C021', 'E014', 'Dine-In', '7-Apr-2024', '16.00', '0.80');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR022', 'C022', 'E017', 'Take Away', '7-Apr-2024', '21.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR023', 'C023', 'E018', 'Take Away', '7-Apr-2024', '21.00', '1.70');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR024', 'C024', 'E027', 'Dine-In', '7-Apr-2024', '83.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR025', 'C025', 'E001', 'Dine-In', '8-Apr-2024', '23.50', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR026', 'C026', 'E004', 'Take Away', '8-Apr-2024', '37.50', '1.90');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR027', 'C027', 'E012', 'Take Away', '8-Apr-2024', '18.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR028', 'C028', 'E015', 'Dine-In', '9-Apr-2024', '14.00', '2.10');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR029', 'C029', 'E019', 'Dine-In', '9-Apr-2024', '40.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR030', 'C030', 'E009', 'Take Away', '9-Apr-2024', '26.50', '5.30');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR031', 'C031', 'E011', 'Take Away', '9-Apr-2024', '12.00', '');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR032', 'C032', 'E014', 'Take Away', '9-Apr-2024', '21.00', '2.10');
INSERT INTO ORDER_S (orderID, cusID, empID, OrderType, orderDate, totalAmount, Discount) VALUES ('OR033', 'C032', 'E014', 'Take Away', '9-Apr-2024', '12.00', '1.20');



--Insert record into Payment Table

INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P001', 'OR001', 'C001', '4-Jan-2024', '37.00', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P002', 'OR002', 'C002', '4-Jan-2024', '26.00', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P003', 'OR003', 'C003', '4-Jan-2024', '13.30', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P004', 'OR004', 'C004', '4-Feb-2024', '11.50', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P005', 'OR005', 'C005', '4-Feb-2024', '13.50', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P006', 'OR006', 'C006', '4-Feb-2024', '21.00', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P007', 'OR007', 'C007', '4-Feb-2024', '20.00', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P008', 'OR008', 'C008', '4-Mar-2024', '12.00', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P009', 'OR009', 'C009', '4-Mar-2024', '26.00', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P010', 'OR010', 'C010', '4-Mar-2024', '17.50', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P011', 'OR011', 'C011', '4-Apr-2024', '7.10', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P012', 'OR012', 'C012', '4-Apr-2024', '13.00', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P013', 'OR013', 'C013', '4-May-2024', '55.20', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P014', 'OR014', 'C014', '4-May-2024', '15.00', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P015', 'OR015', 'C015', '4-May-2024', '17.10', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P016', 'OR016', 'C016', '4-May-2024', '62.00', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P017', 'OR017', 'C017', '4-Jun-2024', '28.80', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P018', 'OR018', 'C018', '4-Jun-2024', '20.40', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P019', 'OR019', 'C019', '4-Jun-2024', '27.00', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P020', 'OR020', 'C020', '4-Jun-2024', '20.00', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P021', 'OR021', 'C021', '4-Jul-2024', '15.20', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P022', 'OR022', 'C022', '4-Jul-2024', '21.00', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P023', 'OR023', 'C023', '4-Jul-2024', '19.30', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P024', 'OR024', 'C024', '4-Jul-2024', '83.00', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P025', 'OR025', 'C025', '4-Aug-2024', '23.50', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P026', 'OR026', 'C026', '4-Aug-2024', '35.60', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P027', 'OR027', 'C027', '4-Aug-2024', '18.00', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P028', 'OR028', 'C028', '4-Sep-2024', '11.90', 'Debit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P029', 'OR029', 'C029', '4-Sep-2024', '40.00', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P030', 'OR030', 'C030', '4-Sep-2024', '21.20', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P031', 'OR031', 'C031', '4-Sep-2024', '12.00', 'E-Wallet');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P032', 'OR032', 'C032', '4-Sep-2024', '18.90', 'Credit Card');
INSERT INTO PAYMENT (pID, orderID, cusID, payDate, payAmount, payMethod) VALUES ('P033', 'OR033', 'C008', '4-Sep-2024', '10.80', 'E-Wallet');


--Insert record into Food_Category Table

INSERT INTO FOOD_CATEGORY (foodCategoryID, foodCategoryName, itemNo) VALUES ('F001', 'Pasta', '5');
INSERT INTO FOOD_CATEGORY (foodCategoryID, foodCategoryName, itemNo) VALUES ('F002', 'Pizza', '6');
INSERT INTO FOOD_CATEGORY (foodCategoryID, foodCategoryName, itemNo) VALUES ('F003', 'Side Dishes', '4');
INSERT INTO FOOD_CATEGORY (foodCategoryID, foodCategoryName, itemNo) VALUES ('F004', 'Burgers', '5');
INSERT INTO FOOD_CATEGORY (foodCategoryID, foodCategoryName, itemNo) VALUES ('F005', 'Beverages', '6');
INSERT INTO FOOD_CATEGORY (foodCategoryID, foodCategoryName, itemNo) VALUES ('F006', 'Desserts', '4');


--Insert record into FoodItem Table

INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I001', 'F001', 'Creamy Garlic Pasta', '12.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I002', 'F001', 'Pumpkin Pasta', '12.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I003', 'F001', 'Cheesy Broccoli Pasta', '13.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I004', 'F001', 'Lemon Chicken Pasta', '14.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I005', 'F001', 'Carbonara Pasta', '12.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I006', 'F002', 'Chicken Pizza', '20.00', '60');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I007', 'F002', 'Beef Pizza', '25.00', '60');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I008', 'F002', 'Deluxe Cheese Pizza', '20.00', '60');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I009', 'F002', 'Island Tuna Pizza', '22.00', '60');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I010', 'F002', 'Veggie Pizza', '18.00', '60');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I011', 'F002', 'Taco Pizza', '20.00', '60');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I012', 'F003', 'Coleslaw', '5.00', '80');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I013', 'F003', 'Garlic Bread', '5.00', '80');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I014', 'F003', 'Potato Wedges', '8.00', '80');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I015', 'F003', 'Onion Ring', '8.00', '80');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I016', 'F004', 'Chicken Burger', '14.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I017', 'F004', 'Beef Burger', '18.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I018', 'F004', 'Turkey Burger', '15.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I019', 'F004', 'Caprese Burger', '18.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I020', 'F004', 'Nacho Burger', '18.00', '70');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I021', 'F005', 'Green Tea', '2.50', '100');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I022', 'F005', 'Latte', '8.00', '100');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I023', 'F005', 'Mocha', '8.00', '100');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I024', 'F005', 'Orange Juice', '3.50', '100');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I025', 'F005', 'Coke', '3.00', '100');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I026', 'F005', 'Lemon Water', '1.50', '100');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I027', 'F006', 'Tiramisu', '10.00', '30');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I028', 'F006', 'Ice Cream', '3.00', '30');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I029', 'F006', 'Burnt Cheesecake', '10.00', '30');
INSERT INTO FOODITEM (itemID, foodCategoryID, foodName, foodUnitPrice, fQuatity) VALUES ('I030', 'F006', 'Apple Pie', '12.00', '30');


