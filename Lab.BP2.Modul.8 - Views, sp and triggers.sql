--1
/* Prepering environment and insertin tables with data
   from AdventureWorks2014 database into Test 
*/

CREATE DATABASE Test
GO

USE Test
GO

SELECT BusinessEntityID, LastName, FirstName, Title
	INTO dbo.Person
FROM AdventureWorks2014.Person.Person
GO

SELECT BusinessEntityID, JobTitle, BirthDate, Gender, HireDate
	INTO dbo.Employees
FROM AdventureWorks2014.HumanResources.Employee
GO

SELECT BusinessEntityID, TerritoryID, SalesQuota, Bonus
	INTO dbo.SalesPerson
FROM AdventureWorks2014.Sales.SalesPerson
GO

SELECT SalesOrderID, CustomerID, OrderDate, DueDate, ShipDate, Status
	INTO dbo.SalesOrderHeader
FROM AdventureWorks2014.Sales.SalesOrderHeader
GO

SELECT *
	INTO dbo.ProductReview
FROM AdventureWorks2014.Production.ProductReview
GO

--2
/* Creating, altering and droping the view object*/

CREATE VIEW EmployeeList
AS 
	SELECT E.BusinessEntityID, P.LastName, P.FirstName
	FROM Person AS P
	INNER JOIN Employees AS E
	ON P.BusinessEntityID = E.BusinessEntityID
GO

SELECT * FROM EmployeeList
GO

ALTER VIEW EmployeeList
AS 
	SELECT E.BusinessEntityID, P.LastName, P.FirstName, E.Gender, E.HireDate
	FROM Person AS P
	INNER JOIN Employees AS E
	ON P.BusinessEntityID = E.BusinessEntityID
GO

SELECT * FROM EmployeeList
GO

--Query the view definition via OBJECT_DEFINITION 
SELECT OBJECT_DEFINITION(OBJECT_ID(N'dbo.EmployeeList'));
GO

ALTER VIEW EmployeeList
WITH ENCRYPTION
AS 
	SELECT E.BusinessEntityID, P.LastName, P.FirstName
	FROM Person AS P
	INNER JOIN Employees AS E
	ON P.BusinessEntityID = E.BusinessEntityID
GO

SELECT OBJECT_DEFINITION(OBJECT_ID(N'dbo.EmployeeList'));
GO

DROP VIEW EmployeeList
GO

--3
/* Creating, executing altering and droping stored procedures*/

CREATE PROCEDURE GetSalesPersonNames
AS 
BEGIN
  SELECT SP.BusinessEntityID, P.LastName, P.FirstName
  FROM SalesPerson AS SP
  INNER JOIN Person AS P
  ON SP.BusinessEntityID = P.BusinessEntityID
  WHERE SP.TerritoryID IS NOT NULL
  ORDER BY SP.BusinessEntityID
END;

EXECUTE GetSalesPersonNames -- execution of stored procedures
GO

ALTER PROCEDURE GetSalesPersonNames
AS 
BEGIN
  SELECT SP.BusinessEntityID, P.LastName, P.FirstName
  FROM SalesPerson AS SP
  INNER JOIN Person AS P
  ON SP.BusinessEntityID = P.BusinessEntityID
  WHERE SP.TerritoryID IS NOT NULL AND SP.SalesQuota IS NOT NULL
  ORDER BY SP.BusinessEntityID
END;

--List of all stored procudures in current database
SELECT SCHEMA_NAME(schema_id) AS SchemaName,
       Name AS ProcedureName
FROM sys.procedures;
GO

DROP PROCEDURE GetSalesPersonNames
GO

--Stored procedure with input parameters
CREATE PROCEDURE OrdersByDueDateAndStatus
	@DueDate datetime, @Status tinyint
AS 
SELECT SalesOrderID, OrderDate, CustomerID
FROM SalesOrderHeader
WHERE DueDate = @DueDate AND Status = @Status;
GO

EXEC OrdersByDueDateAndStatus '20140712',5;
GO
EXEC OrdersByDueDateAndStatus '20131115'; --Will produce error - missing parameter
GO
EXEC OrdersByDueDateAndStatus @DueDate = '20110612',@Status = 5;
GO

ALTER PROCEDURE OrdersByDueDateAndStatus
	@DueDate datetime, @Status tinyint = 5
AS 
SELECT SalesOrderID, OrderDate, CustomerID
FROM SalesOrderHeader
WHERE DueDate = @DueDate AND Status = @Status;
GO

EXEC OrdersByDueDateAndStatus '20131115'
GO

DROP PROCEDURE OrdersByDueDateAndStatus
GO

--Stored procedure with output parameters
CREATE PROC GetOrderCountByDueDate
@DueDate datetime, @OrderCount int OUTPUT
AS
  SELECT @OrderCount = COUNT(*)
  FROM SalesOrderHeader 
  WHERE DueDate = @DueDate;
GO

DECLARE @DueDate datetime = '20140712';
DECLARE @OrderCount int;
EXEC GetOrderCountByDueDate @DueDate, @OrderCount OUTPUT;
SELECT @OrderCount;
GO

DROP PROCEDURE GetOrderCountByDueDate
GO

CREATE PROCEDURE EmployeeList
WITH ENCRYPTION
AS 
	SELECT E.BusinessEntityID, P.LastName, P.FirstName
	FROM Person AS P
	INNER JOIN Employees AS E
	ON P.BusinessEntityID = E.BusinessEntityID
GO

DROP PROCEDURE EmployeeList
GO

--4
/* Working with DDL and DML triggers*/

CREATE TRIGGER ObjectDropingPrevention
ON DATABASE 
FOR DROP_TABLE, ALTER_TABLE, DROP_VIEW 
AS 
   PRINT 'Brisanje i izmjena nad objetima nije dozvoljena!' 
   ROLLBACK ;
GO

DROP VIEW EmployeeList --will not work
GO


CREATE TRIGGER ProductReview_Update
ON ProductReview
AFTER UPDATE AS 
BEGIN
    SET NOCOUNT ON;
    UPDATE PR
    SET PR.ModifiedDate = SYSDATETIME()
    FROM ProductReview AS PR
    INNER JOIN inserted AS I
    ON I.ProductReviewID = PR.ProductReviewID;
END;
GO

SELECT *
FROM ProductReview
GO

UPDATE ProductReview
SET ReviewerName = 'John Doe'
WHERE ProductReviewID = 1
GO

SELECT ProductReviewID, ReviewerName, ModifiedDate
FROM ProductReview
GO

USE master
GO
DROP DATABASE  Test
GO