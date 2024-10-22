create proc uspFind(@modelyear as int)
as
begin
select * from production.products where model_year = @modelyear
end

uspFind 2019


-- questions


-- Create the stored procedure
CREATE PROCEDURE GetCustomersByProduct
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.customer_id AS CustomerID,
        CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
        o.order_date AS PurchaseDate
    FROM 
        sales.customers c
    INNER JOIN 
        sales.orders o ON c.customer_id = o.customer_id
    INNER JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    WHERE 
        oi.product_id = @ProductID; 
END


EXEC GetCustomersByProduct @ProductID = 3;

create database test1

CREATE TABLE Department (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

INSERT INTO Department (ID, Name)
VALUES (1, 'HR'), 
       (2, 'IT'), 
       (3, 'Finance'), 
       (4, 'Marketing');

CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Gender CHAR(1), 
    DOB DATE,
    DeptId INT,
    FOREIGN KEY (DeptId) REFERENCES Department(ID)
);

INSERT INTO Employee (ID, Name, Gender, DOB, DeptId)
VALUES (1, 'Manan', 'M', '1990-05-10', 2),
       (2, 'Varun', 'M', '1995-09-20', 1),
       (3, 'Vijaysree', 'F', '1988-11-12', 3),
       (4, 'Vivek', 'M', '1992-03-15', 4);


--a
CREATE PROCEDURE UpdateEmployeeDetails
    @EmployeeID INT,
    @NewName VARCHAR(100),
    @NewGender CHAR(1),
    @NewDOB DATE,
    @NewDeptId INT
AS
BEGIN
    UPDATE Employee
    SET Name = @NewName,
        Gender = @NewGender,
        DOB = @NewDOB,
        DeptId = @NewDeptId
    WHERE ID = @EmployeeID;
END;

--b
CREATE PROCEDURE GetEmployeesByGenderAndDept
    @Gender CHAR(1),
    @DeptId INT
AS
BEGIN
    SELECT ID, Name, Gender, DOB, DeptId
    FROM Employee
    WHERE Gender = @Gender
      AND DeptId = @DeptId;
END;

--c
CREATE PROCEDURE GetEmployeeCountByGender
    @Gender CHAR(1)
AS
BEGIN
    SELECT COUNT(*) AS EmployeeCount
    FROM Employee
    WHERE Gender = @Gender;
END;

GetEmployeeCountByGender M

GetEmployeesByGenderAndDept M , 1


--3
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    ListPrice DECIMAL(10, 2) NOT NULL
);

-- Example data
INSERT INTO Products (ProductID, ProductName, ListPrice)
VALUES (1, 'Mountain Bike', 500.00),
       (2, 'Road Bike', 750.00),
       (3, 'Hybrid Bike', 600.00);

CREATE FUNCTION dbo.CalculateTotalPrice
(
    @ProductID INT,
    @Quantity INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalPrice DECIMAL(10, 2);

    SELECT @TotalPrice = ListPrice * @Quantity
    FROM Products
    WHERE ProductID = @ProductID;

    IF @TotalPrice IS NULL
    BEGIN
        RETURN 0.00;
    END

    RETURN @TotalPrice;
END;

DECLARE @ProductID INT = 1;  
DECLARE @Quantity INT = 3;    

SELECT dbo.CalculateTotalPrice(@ProductID, @Quantity) AS TotalPrice;
















