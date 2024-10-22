CREATE DATABASE test2;
GO

USE test2;
GO

CREATE SCHEMA sales;
GO

CREATE TABLE sales.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(255) NOT NULL
);
GO

CREATE TABLE sales.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES sales.Customers(CustomerID) ON DELETE CASCADE
);
GO

CREATE TABLE sales.OrderItems (
    OrderID INT NOT NULL,
    ItemID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    ListPrice DECIMAL(10, 2) NOT NULL,
    Discount DECIMAL(4, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (OrderID) REFERENCES sales.Orders(OrderID) ON DELETE CASCADE
);
GO

CREATE FUNCTION sales.CalculateTotalSalesPerProduct()
RETURNS @SalesTable TABLE (
    ProductID INT,
    TotalSales DECIMAL(10, 2)
)
AS
BEGIN
    INSERT INTO @SalesTable (ProductID, TotalSales)
    SELECT 
        oi.ProductID,
        SUM(oi.Quantity * (oi.ListPrice - oi.Discount)) AS TotalSales
    FROM 
        sales.OrderItems oi
    GROUP BY 
        oi.ProductID;

    RETURN;
END;
GO

CREATE FUNCTION sales.GetTotalAmountSpentByCustomers()
RETURNS @CustomerSpending TABLE (
    CustomerID INT,
    TotalAmountSpent DECIMAL(10, 2)
)
AS
BEGIN
    INSERT INTO @CustomerSpending (CustomerID, TotalAmountSpent)
    SELECT 
        c.CustomerID,
        SUM(oi.Quantity * (oi.ListPrice - oi.Discount)) AS TotalAmountSpent
    FROM 
        sales.Customers c
    LEFT JOIN 
        sales.Orders o ON c.CustomerID = o.CustomerID
    LEFT JOIN 
        sales.OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY 
        c.CustomerID;

    RETURN;
END;
GO


SELECT * FROM sales.CalculateTotalSalesPerProduct();

SELECT * FROM sales.GetTotalAmountSpentByCustomers();


-- Insert Sample Data into Customers Table
INSERT INTO sales.Customers (FirstName, LastName, Email) VALUES
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Emily', 'Johnson', 'emily.johnson@example.com'),
('Michael', 'Brown', 'michael.brown@example.com'),
('Jessica', 'Davis', 'jessica.davis@example.com');

-- Insert Sample Data into Orders Table
INSERT INTO sales.Orders (CustomerID, OrderDate) VALUES
(1, '2024-10-01 10:30:00'),
(2, '2024-10-02 14:45:00'),
(1, '2024-10-03 09:15:00'),
(3, '2024-10-04 11:00:00'),
(4, '2024-10-05 15:30:00');

-- Insert Sample Data into OrderItems Table
INSERT INTO sales.OrderItems (OrderID, ProductID, Quantity, ListPrice, Discount) VALUES
(1, 101, 2, 15.00, 1.00), -- John Doe's first order
(1, 102, 1, 25.00, 0.00), -- John Doe's second order
(2, 103, 3, 5.00, 0.50), -- Jane Smith's order
(3, 104, 1, 100.00, 5.00), -- John Doe's second order
(4, 105, 4, 20.00, 2.00), -- Emily Johnson's order
(5, 106, 1, 50.00, 0.00); -- Jessica Davis's order


