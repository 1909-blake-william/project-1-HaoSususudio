-- 1.0 Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.

-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.

-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT  * 
FROM    Employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT  * 
FROM    Employee
WHERE   LastName = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT  * 
FROM    Employee
WHERE   FirstName = 'Andrew' 
AND     REPORTSTO IS NULL;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT  *
FROM    Album
ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT  FirstName
FROM    Customer
ORDER BY city ASC;

-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO Genre (GenreId, Name)
VALUES  (101, 'Children');
INSERT INTO Genre (GenreId, Name)    
VALUES  (102,'Halloween');
-- Task – Insert two new records into Employee table
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) 
VALUES (9, 'Adams2', 'Andrew2', 'Janitor', TO_DATE('1962-2-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2002-8-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '11120 Jasper Ave NW', 'Edmonton', 'AB', 'Canada', 'T5K 2N1', '+1 (780) 428-9482', '+1 (780) 428-3457', 'andrew@chinookcorp.com');
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) 
VALUES (10, 'Adams3', 'Andrew3', 'Janitor', TO_DATE('1962-2-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2002-8-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '11120 Jasper Ave NW', 'Edmonton', 'AB', 'Canada', 'T5K 2N1', '+1 (780) 428-9482', '+1 (780) 428-3457', 'andrew@chinookcorp.com');
-- Task – Insert two new records into Customer table
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, Country, PostalCode, Phone, Email, SupportRepId) 
VALUES (60, 'Diego', 'Gutiérrez', '307 Macacha Güemes', 'Buenos Aires', 'Argentina', '1106', '+54 (0)11 4311 4333', 'diego.gutierrez@yahoo.ar', 4);
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, Country, PostalCode, Phone, Email, SupportRepId) 
VALUES (61, 'Diego', 'Gutiérrez', '307 Macacha Güemes', 'Buenos Aires', 'Argentina', '1106', '+54 (0)11 4311 4333', 'diego.gutierrez@yahoo.ar', 4);

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE  Customer
SET     FirstName = 'Robert', LastName = 'Walter'
WHERE   FirstName = 'Aaron' AND LastName = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE  Artist
SET     Name = 'CCR'
WHERE   Name = 'Creedence Clearwater Revival';

-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT  *
FROM    Invoice
WHERE   BillingAddress LIKE 'T%';

-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT  *
FROM    Invoice
WHERE   Total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT  *
FROM    Employee
WHERE   HireDate BETWEEN TO_DATE('01-JUN-2003') AND TO_DATE('01-MAR-2004');

-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter 
-- (There may be constraints that rely on this, find out how to resolve them).
----------Re-insert customer and invoice records if deleted already----------------
------TABLE Customer--------------------
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, State, Country, PostalCode, Phone, Email, SupportRepId) 
VALUES (32, 'Robert', 'Walter', '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', '+1 (204) 452-6452', 'aaronmitchell@yahoo.ca', 4);
------TABLE Invoice------------------------
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) VALUES (50, 32, TO_DATE('2009-8-6 00:00:00','yyyy-mm-dd hh24:mi:ss'), '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', 1.98);
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) VALUES (61, 32, TO_DATE('2009-9-16 00:00:00','yyyy-mm-dd hh24:mi:ss'), '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', 13.86);
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) VALUES (116, 32, TO_DATE('2010-5-17 00:00:00','yyyy-mm-dd hh24:mi:ss'), '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', 8.91);
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) VALUES (245, 32, TO_DATE('2011-12-22 00:00:00','yyyy-mm-dd hh24:mi:ss'), '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', 1.98);
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) VALUES (268, 32, TO_DATE('2012-3-25 00:00:00','yyyy-mm-dd hh24:mi:ss'), '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', 3.96);
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) VALUES (290, 32, TO_DATE('2012-6-27 00:00:00','yyyy-mm-dd hh24:mi:ss'), '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', 5.94);
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) VALUES (342, 32, TO_DATE('2013-2-15 00:00:00','yyyy-mm-dd hh24:mi:ss'), '696 Osborne Street', 'Winnipeg', 'MB', 'Canada', 'R3L 2B9', 0.99);
------TABLE InvoiceLine---------------------
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (267, 50, 1626, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (268, 50, 1628, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (326, 61, 1955, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (327, 61, 1964, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (328, 61, 1973, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (329, 61, 1982, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (330, 61, 1991, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (331, 61, 2000, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (332, 61, 2009, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (333, 61, 2018, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (334, 61, 2027, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (335, 61, 2036, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (336, 61, 2045, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (337, 61, 2054, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (338, 61, 2063, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (339, 61, 2072, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (621, 116, 251, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (622, 116, 257, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (623, 116, 263, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (624, 116, 269, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (625, 116, 275, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (626, 116, 281, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (627, 116, 287, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (628, 116, 293, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (629, 116, 299, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1329, 245, 1113, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1330, 245, 1114, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1447, 268, 1816, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1448, 268, 1818, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1449, 268, 1820, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1450, 268, 1822, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1565, 290, 2522, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1566, 290, 2526, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1567, 290, 2530, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1568, 290, 2534, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1569, 290, 2538, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1570, 290, 2542, 0.99, 1);
INSERT INTO InvoiceLine (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES (1860, 342, 857, 0.99, 1);
-------Turn ON DELETE CASCADE for affacted tables---------------
ALTER TABLE Customer 
DROP    CONSTRAINT FK_CustomerSupportRepId;
ALTER TABLE Customer         
ADD     CONSTRAINT FK_CustomerSupportRepId
        FOREIGN KEY (SupportRepId) 
        REFERENCES Employee (EmployeeId)
        ON DELETE CASCADE;

ALTER TABLE Invoice
DROP    CONSTRAINT FK_InvoiceCustomerId;
ALTER TABLE Invoice 
ADD     CONSTRAINT FK_InvoiceCustomerId
        FOREIGN KEY (CustomerId) 
        REFERENCES Customer (CustomerId)
        ON DELETE CASCADE;

ALTER TABLE InvoiceLine
DROP    CONSTRAINT FK_InvoiceLineInvoiceId;
ALTER TABLE InvoiceLine 
ADD     CONSTRAINT FK_InvoiceLineInvoiceId
        FOREIGN KEY (InvoiceId) 
        REFERENCES Invoice (InvoiceId)
        ON DELETE CASCADE;
----------Excute DELETE--------------------------------------------
DELETE 
FROM    Customer
WHERE   FirstName = 'Robert' AND LastName = 'Walter';
-----------Turn off DELETE CASCADE for security---------
ALTER TABLE Customer 
DROP    CONSTRAINT FK_CustomerSupportRepId;
ALTER TABLE Customer         
ADD     CONSTRAINT FK_CustomerSupportRepId
        FOREIGN KEY (SupportRepId) 
        REFERENCES Employee (EmployeeId);

ALTER TABLE Invoice
DROP    CONSTRAINT FK_InvoiceCustomerId;
ALTER TABLE Invoice 
ADD     CONSTRAINT FK_InvoiceCustomerId
        FOREIGN KEY (CustomerId) 
        REFERENCES Customer (CustomerId);

ALTER TABLE InvoiceLine
DROP    CONSTRAINT FK_InvoiceLineInvoiceId;
ALTER TABLE InvoiceLine 
ADD     CONSTRAINT FK_InvoiceLineInvoiceId
        FOREIGN KEY (InvoiceId) 
        REFERENCES Invoice (InvoiceId);
-----------------------------------------------------------

-- 3.0 SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database

-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
SELECT  TO_CHAR
        ( SYSDATE,'DD-MON-YYYY HH:MI:SS AM') "NOW"
FROM    dual;
-- Task – create a function that returns the length of a mediatype from the mediatype table
SELECT  LENGTH(Name)
FROM    mediatype;

-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
SELECT  AVG(total)
FROM    invoice;
-- Task – Create a function that returns the most expensive track
SELECT  *
FROM    track
WHERE   UnitPrice 
        = (SELECT MAX(UnitPrice) FROM track);

-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of 
-- invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION get_avg_price
RETURN number -- return type
AS
avg_price number;
BEGIN
    SELECT AVG(UnitPrice) INTO avg_price FROM InvoiceLine;
    RETURN avg_price;
END;
/
--Excute get_avg_price
SELECT get_avg_price FROM dual;
--

-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees 
-- who are born after 1968.
-----------P.S. Delete old t_record and t_table before compiling new ones----------------------
DROP TYPE t_table; 
DROP TYPE t_record;
----------------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_record 
AS 
OBJECT 
(
    row_num number,
    FirstName varchar2(20),
    LastName varchar2(20),
    BirthDate DATE
);
/
CREATE OR REPLACE TYPE t_table 
AS 
TABLE of t_record;
/


CREATE OR REPLACE   
FUNCTION 
get_emplooyee_DOB_after (date_of_birth IN DATE)
RETURN t_table 
AS
v_ret   t_table;
BEGIN
    SELECT
        t_record(rownum, FirstName, LastName, date_of_birth) 
    BULK COLLECT INTO
        v_ret
    FROM
        Employee
    WHERE
        BirthDate >= date_of_birth;
    RETURN v_ret;
END;
/
SELECT  *
FROM    TABLE(get_emplooyee_DOB_after('01-JAN-1968'));

-- 4.0 Stored Procedures
-- In this section you will be creating and executing stored procedures. 
-- You will be creating various types of stored procedures that take 
-- input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE PROCEDURE select_name_of_all_employee 
(c_out OUT sys_refcursor)
AS
BEGIN
    OPEN c_out FOR
    SELECT  FirstName, LastName
    FROM    Employee;
END;
/
SET     SERVEROUTPUT ON
DECLARE c_out sys_refcursor;
        first_name varchar2(20);
        last_name varchar2(20);
BEGIN
    select_name_of_all_employee(c_out);
    LOOP 
        FETCH c_out
        INTO  first_name, last_name;
        EXIT WHEN c_out%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(first_name || ' | ' || last_name);
  END LOOP;
  CLOSE c_out;
END;
/

-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE PROCEDURE update_employee 
(
    EmployeeId_in IN number,
    LastName_in IN VARCHAR2,
    FirstName_in IN VARCHAR2,
    Title_in IN VARCHAR2,
    ReportsTo_in IN NUMBER,
    BirthDate_in IN DATE,
    HireDate_in IN DATE,
    Address_in IN VARCHAR2,
    City_in IN VARCHAR2,
    State_in IN VARCHAR2,
    Country_in IN VARCHAR2,
    PostalCode_in IN VARCHAR2,
    Phone_in IN VARCHAR2,
    Fax_in IN VARCHAR2,
    Email_in IN VARCHAR2
)
AS
BEGIN
    UPDATE  Employee
    SET
        LastName = LastName_in,
        FirstName = FirstName_in,
        Title = Title_in,
        ReportsTo = ReportsTo_in,
        BirthDate = BirthDate_in,
        HireDate = HireDate_in,
        Address = Address_in,
        City = City_in,
        State = State_in,
        Country = Country_in,
        PostalCode = PostalCode_in,
        Phone  = Phone_in,
        Fax = Fax_in,
        Email = Email_in
    WHERE   EmployeeId = EmployeeId_in;
END;
/
----- Excuting  ----------
BEGIN
    update_employee(8, 'Callahan128', 'Laura128', 'IT Staff', 6, TO_DATE('1968-1-9 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2004-3-4 00:00:00','yyyy-mm-dd hh24:mi:ss'), '923 7 ST NW', 'Lethbridge', 'AB', 'Canada', 'T1H 1Y8', '+1 (403) 467-3351', '+1 (403) 467-8772', 'laura@chinookcorp.com');
END;
/
----- SELECT UPDATED row --
SELECT  *
FROM    Employee
WHERE   EmployeeId = 8;


-- Task – Create a stored procedure that returns the managers of an employee.
/**
get_managers should use a LOOP to call get_direct_manager recursively
to return manger all the way to the top of the chain of command, Adam.
However this is not yet implemented.
It simply passes EmployeeId_in and c_out for the time being.
**/
CREATE OR REPLACE PROCEDURE get_mangers
(
    EmployeeId_in IN number,
    c_out OUT sys_refcursor
)
AS
c_direct_manger sys_refcursor;
BEGIN
    -- OPEN c_out FOR
        get_direct_manger(EmployeeId_in, c_out);
        -- c_out := c_direct_manger;
END;
/

CREATE OR REPLACE PROCEDURE get_direct_manger
(
    EmployeeId_in IN number,
    c_direct_manger OUT sys_refcursor
)
AS
BEGIN
    OPEN    c_direct_manger FOR
    SELECT  e2.EmployeeId, e2.FirstName, e2.LastName
    FROM    Employee e1 LEFT JOIN Employee e2
    ON      e1.ReportsTo = e2.EmployeeId
    WHERE   EmployeeId_in = e1.EmployeeId;
END;
/
----- Excuting  ----------
SET     SERVEROUTPUT ON
DECLARE c_out sys_refcursor;
        manager_employeeId number;
        first_name varchar2(20);
        last_name varchar2(20);
BEGIN
    get_mangers(2, c_out);
    LOOP 
        FETCH c_out
        INTO  manager_employeeId, first_name, last_name;
    EXIT WHEN c_out%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(manager_employeeId || ' ' || first_name || ' ' || last_name);
  END LOOP;
  CLOSE c_out;
END;
/

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE PROCEDURE get_name_and_company
(
    CustomerId_in IN number,
    c_out OUT sys_refcursor
)
AS
BEGIN
    OPEN    c_out FOR
    SELECT  CustomerId, FirstName, LastName, Company
    FROM    Customer
    WHERE   CustomerId_in = CustomerId;
END;
/
SET     SERVEROUTPUT ON
DECLARE c_out sys_refcursor;
        customer_id number;
        first_name varchar2(40);
        last_name varchar2(20);
        company varchar2(80);
BEGIN
    get_name_and_company(5, c_out);
    LOOP 
        FETCH c_out
        INTO  customer_id, first_name, last_name, company;
        EXIT WHEN c_out%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(customer_id || ' ' || first_name || ' ' || last_name || ' ' || company);
    END LOOP;
  CLOSE c_out;
END;
/

-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain 
-- DML statements are executed on a table.

-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE OR REPLACE TRIGGER employee_record_inserted
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
    dbms_output.put_line('Message by TRIGGER: A New record is inserted into Employee!!!');
END;
/
SET     SERVEROUTPUT ON
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) 
VALUES (9, 'Adams2', 'Andrew2', 'Janitor', TO_DATE('1962-2-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2002-8-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '11120 Jasper Ave NW', 'Edmonton', 'AB', 'Canada', 'T5K 2N1', '+1 (780) 428-9482', '+1 (780) 428-3457', 'andrew@chinookcorp.com');

DELETE 
FROM    Employee
WHERE   EmployeeID = 9;

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE OR REPLACE TRIGGER employee_record_inserted
AFTER INSERT OR UPDATE ON Employee
FOR EACH ROW
BEGIN
    dbms_output.put_line('Message by TRIGGER: A New record is updated or inserted into Employee!!!');
END;
/
SET     SERVEROUTPUT ON
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) 
VALUES (9, 'Adams2', 'Andrew2', 'Janitor', TO_DATE('1962-2-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2002-8-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '11120 Jasper Ave NW', 'Edmonton', 'AB', 'Canada', 'T5K 2N1', '+1 (780) 428-9482', '+1 (780) 428-3457', 'andrew@chinookcorp.com');

UPDATE  Employee
SET     LastName = 'Adams64', FirstName = 'Andrew64'
WHERE   EmployeeID = 9;

DELETE 
FROM Employee
WHERE EmployeeID = 9;

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE OR REPLACE TRIGGER custermer_record_deleted
AFTER DELETE ON Customer
FOR EACH ROW
BEGIN
    dbms_output.put_line('Message by TRIGGER: A New record is DELETED FROM Customer!!!');
END;
/
SET     SERVEROUTPUT ON
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, Country, PostalCode, Phone, Email, SupportRepId) 
VALUES (100, 'Puja2', 'Srivastava2', '3,Raj Bhavan Road', 'Bangalore', 'India', '560001', '+91 080 22289999', 'puja_srivastava@yahoo.in', 3);

DELETE
FROM    Customer
WHERE   CustomerId = 100;
-- Task – Create a trigger that restricts the deletion of any invoice that is priced over 50 dollars.
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total) 
VALUES      (3000, 15, TO_DATE('2019-4-26 00:00:00','yyyy-mm-dd hh24:mi:ss'), '700 W Pender Street', 'Vancouver', 'BC', 'Canada', 'V6C 1G8', 55);

CREATE OR REPLACE TRIGGER no_delete_invoice_over_50
BEFORE DELETE ON Invoice
FOR EACH ROW
WHEN    (old.Total > 50)
BEGIN
    raise_application_error(-20001,'Message by TRIGGER: DELETE from invoice with total over 50 is blocked!!!');
END;
/
SET     SERVEROUTPUT ON
DELETE
FROM    Invoice
WHERE   InvoiceId = 3000;

-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer 
-- and the invoiceId.
SELECT c.firstname, c.lastname, i.invoiceId
FROM customer c
INNER JOIN invoice i
ON  c.customerId = i.customerId
ORDER BY c.customerId;

-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, 
-- specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT c.CustomerId, c.firstname, c.lastname, i.invoiceId, i.total
FROM customer c
LEFT JOIN invoice i
ON  c.customerId = i.customerId
ORDER BY c.customerId;

-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT alb.title, ar.name
FROM album alb
RIGHT JOIN artist ar
ON alb.artistId = ar.artistId
ORDER BY alb.title;

-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
/**** Over 5000 rows will be generated by this inquery*****/
SELECT alb.title, ar.name
FROM album alb
CROSS JOIN artist ar;

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT  e1.EmployeeID, e1.FirstName, e1.LastName, e1.reportsto, e2.FirstName, e2.LastName
FROM    Employee e1 LEFT JOIN Employee e2
ON      e1.ReportsTo = e2.EmployeeId
ORDER BY    e1.EmployeeId;