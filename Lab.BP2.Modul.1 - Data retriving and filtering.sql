--1
USE AdventureWorks2014
GO
SELECT Name, ProductNumber
FROM Production.Product

--2
USE AdventureWorks2014
GO
SELECT *
FROM Production.Product

--3
USE AdventureWorks2014
GO
SELECT Name, ProductNumber, Color , DaysToManufacture
FROM Production.Product
WHERE DaysToManufacture = 2


--4
USE AdventureWorks2014
GO
SELECT Name, Weight 
FROM Production.Product
WHERE Weight >= 1000

--5
USE AdventureWorks2014
GO
SELECT Name, ProductNumber
FROM Production.Product
WHERE Name = 'Chainring'

--6
USE AdventureWorks2014
GO
SELECT Name, ProductNumber
FROM Production.Product
WHERE Name LIKE '[^A]_f%'

--7
USE AdventureWorks2014
GO
SELECT ProductNumber, ListPrice, DaysToManufacture
FROM Production.Product
WHERE ListPrice<2000 AND DaysToManufacture=1

--8
USE AdventureWorks2014
GO
SELECT ProductNumber, ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN 50 AND 100

--9
USE AdventureWorks2014
GO
SELECT ProductNumber, ListPrice
FROM Production.Product
WHERE ListPrice IN (52.64, 74.99, 147.14)

--10
USE AdventureWorks2014
GO
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE '[^AB]_[CD]%' AND ListPrice BETWEEN 5 AND 10

--11
USE AdventureWorks2014
GO
SELECT Name, Color
FROM Production.Product
WHERE Color IS NULL

--12
USE AdventureWorks2014
GO
SELECT Name, Color
FROM Production.Product
WHERE Color IS NOT NULL

--13
USE AdventureWorks2014
GO
SELECT Name, ISNULL(Color,'N/A') 
FROM Production.Product

--14
USE AdventureWorks2014
GO
SELECT TOP 100 FirstName, LastName
FROM Person.Person
ORDER BY FirstName

--15
USE AdventureWorks2014
GO
SELECT TOP 100 FirstName, LastName
FROM Person.Person
ORDER BY FirstName, LastName DESC

--16
USE AdventureWorks2014
GO
SELECT DISTINCT Color
FROM Production.Product

--17
USE AdventureWorks2014
GO
SELECT DISTINCT Color, DaysToManufacture
FROM Production.Product

--18
USE AdventureWorks2014
GO
SELECT Name AS "Product Name", 
       ProductNumber AS [Product Number]
FROM Production.Product

--19
USE AdventureWorks2014
GO
SELECT P.Name, P.ProductNumber AS Number
FROM Production.Product AS P

--20
USE AdventureWorks2014
GO
SELECT ('Proizvod ' + ProductNumber) AS Broj,
	   ListPrice AS [Stara cijena], 
       (ListPrice * 1.17) AS [Nova cijena]
FROM Production.Product
WHERE ListPrice > 0

--21

SELECT SUBSTRING('Headset Ball Bearings', 9, 4)

SELECT LEFT('Headset Ball Bearings', 7)

SELECT LOWER('Headset Ball Bearings')

SELECT REPLACE('Headset Ball Bearings','Ball','BALL')

SELECT LEN('Headset Ball Bearings')


--22

SELECT CONCAT(ProductNumber,', ', ISNULL(Color,'N/A')) AS 'Broj i boja'
FROM Production.Product

--23

SELECT UPPER (Name), 
	   SUBSTRING (ProductNumber,4,4), Color
FROM Production.Product

--24
SELECT Name, ProductNumber,
   REPLACE(ProductNumber, SUBSTRING(ProductNumber,4,4),'XXXX')    
FROM Production.Product
