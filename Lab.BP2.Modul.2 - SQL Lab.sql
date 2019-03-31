USE Northwind
GO

SELECT * FROM dbo.Orders

--0
SELECT CustomerID, ShipCountry, ShipRegion
FROM Orders
WHERE ShipRegion is  NULL


SELECT CustomerID,ShipCountry,ShipRegion
FROM Orders
WHERE ShipRegion IS NOT NULL

--1
SELECT 'Naruèitelj ',+ CustomerID, + ' ima broj narudzbe: '+ CONVERT(nvarchar(5),OrderID)
FROM Orders

--2
SELECT CustomerID,
	   LOWER(CustomerID + SUBSTRING(ShipCountry, 1, 3)+'@fit.ba' ) AS email,
	   ShipCountry
FROM Orders

SELECT CustomerID,
	   LOWER(CustomerID + SUBSTRING(ShipCountry, 1, 3)+'@fit.ba' ) AS email,
	   ShipCountry
FROM Orders
WHERE ShipCountry IN ('Venezuela', 'Brasil', 'Germany')

SELECT DISTINCT
	   LOWER(CustomerID + SUBSTRING(ShipCountry, 1, 3)+'@fit.ba' ) AS email
FROM Orders
WHERE ShipCountry IN ('Venezuela', 'Brasil', 'Germany')

--3
USE Northwind
SELECT LOWER (LastName + '.' + FirstName + '@' + City + '.com') AS Email,
REPLACE (SUBSTRING ( REVERSE ((CONVERT (nvarchar,Notes)+Title+Address)),17,8), '-', '#') AS Lozinka,
DATEDIFF (year, BirthDate, GETDATE()) AS Godine
FROM dbo.Employees
WHERE Address IS NOT NULL
ORDER BY Godine DESC