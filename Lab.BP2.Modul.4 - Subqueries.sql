--1
USE AdventureWorks2014
GO

SELECT LastName, FirstName, Title --outer query
FROM Person.Person
WHERE Title IN 
	  (SELECT DISTINCT Title --inner query
		FROM Person.Person
       WHERE Title IS NOT NULL)
ORDER BY LastName

--2
--Error - Subquery returned more than 1 value
SELECT LastName, FirstName
FROM Person.Person
WHERE Title = 
	  (SELECT DISTINCT Title
		FROM Person.Person
       WHERE Title IS NOT NULL)
ORDER BY LastName

--3
--Without subquery
SELECT LastName, FirstName, Title
FROM Person.Person
WHERE Title IN ('Sr.', 'Mrs.', 'Sra.', 'Ms.', 'Ms', 'Mr.')
ORDER BY LastName

--4

SELECT LastName, FirstName, Title
FROM Person.Person
WHERE Title = 
	  (SELECT DISTINCT Title
		FROM Person.Person
       WHERE Title = 'Ms.')
ORDER BY LastName

--5

--Join version
SELECT PS.Name 
FROM Production.ProductSubcategory AS PS 
	 INNER JOIN  Production.ProductCategory AS PC 
	 ON PC.ProductCategoryID = PS.ProductCategoryID
WHERE PC.Name = 'Bikes'

--Subquery version
SELECT Name 
FROM Production.ProductSubcategory
WHERE ProductCategoryID IN (SELECT ProductCategoryID
							FROM Production.ProductCategory
							WHERE Name = 'Bikes')
	
--6

--Subquery in SELECT list
SELECT Name, Weight,
	(SELECT AVG (Weight) FROM Production.Product)
		AS 'Avarage',
	 Weight - (SELECT AVG (Weight) FROM Production.Product)
		AS 'Difference'
FROM Production.Product
WHERE Weight IS NOT NULL AND Weight > 800
ORDER BY Weight DESC


--7

--Sampling the table
SELECT * FROM Person.Person

--Scalar value
SELECT LastName, Title
FROM Person.Person
WHERE LastName = (SELECT LastName
		FROM Person.Person
		WHERE LastName = 'Abbas')
ORDER BY LastName 


SELECT LastName, Title
FROM Person.Person
WHERE Title = (SELECT Title
		FROM Person.Person
		WHERE LastName = 'Abbas')
ORDER BY LastName 


--8

--Correlated subquery where inner part is executing for each row from outer part
SELECT SalesOrderID, CustomerID
FROM Sales.SalesOrderHeader AS SOH
WHERE 10 > (SELECT OrderQty
			FROM Sales.SalesOrderDetail AS SOD
			WHERE SOH.SalesOrderID = SOD.SalesOrderID
			AND SOD.ProductID = 778)


--9

--Building correlated subquery from two separated parts
SELECT Name, ListPrice
FROM Production.Product AS P1

SELECT AVG (ListPrice)
FROM Production.Product AS P2

--Merged version
SELECT Name, ListPrice
FROM Production.Product AS P1
WHERE 3500 < (SELECT AVG (ListPrice)
			  FROM Production.Product AS P2
			  WHERE P1.ProductID = P2.ProductID)

