--1
USE AdventureWorks2014
GO

SELECT TOP 1000 * FROM Production.Product

SELECT ListPrice,Size, DaysToManufacture
FROM Production.Product

USE AdventureWorks2014
SELECT MAX (ListPrice) AS MaxListPrice, MIN (ListPrice) AS MinListPrice, 
	   AVG (CONVERT (int, Size)) AS AvgProductSize,
	   SUM (DaysToManufacture) AS TotalDaysToManifacture
FROM Production.Product
WHERE ISNUMERIC (Size) = 1

--2
SELECT MIN (SellEndDate), MAX (SellEndDate)
FROM Production.Product


--3
SELECT COUNT (*), COUNT (SellEndDate)
FROM Production.Product



--4
SELECT COUNT (Weight) AS CountOfWeights, AVG (Weight) AS Average
FROM Production.Product

--5
SELECT COUNT (*), COUNT (Weight),
	   AVG (Weight), AVG (ISNULL (Weight, 0))
FROM Production.Product

--6

SELECT * FROM Purchasing.PurchaseOrderDetail
GO

SELECT SUM (OrderQty) AS TotalOrderQty
	FROM Purchasing.PurchaseOrderDetail
WHERE ProductID = 1 AND DueDate < '2014-06-14'


--7
SELECT COUNT (EmployeeID) AS NumberOfOrders, SUM (SubTotal) AS TotalProfit, 
	   AVG (Freight) AS AverageFreight, MAX (TaxAmt) AS MaxTax
FROM Purchasing.PurchaseOrderHeader
WHERE EmployeeID = 255 AND DATEDIFF (DAY, OrderDate,ShipDate) < 10


--8
SELECT ProductID, COUNT (ProductID) AS ProductSales, 
				  SUM (LineTotal) As Profit
FROM Purchasing.PurchaseOrderDetail
ORDER BY ProductID

--9
SELECT ProductID, COUNT (ProductID) AS ProductSales, 
				  SUM (LineTotal) As Profit
FROM Purchasing.PurchaseOrderDetail
GROUP BY ProductID
ORDER BY ProductID

--10
SELECT SUM (OrderQty) AS TotalOrderQty
FROM Purchasing.PurchaseOrderDetail
HAVING SUM (OrderQty) > 1000

--11

SELECT ProductID, LocationID, SUM (Quantity) AS TotalQuantity
FROM Production.ProductInventory
GROUP BY ProductID, LocationID
ORDER BY ProductID, LocationID DESC
