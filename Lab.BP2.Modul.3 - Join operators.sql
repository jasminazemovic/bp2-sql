USE AdventureWorks2014
GO

SELECT P.ProductNumber, R.Comments
	FROM Production.Product P 
		INNER JOIN Production.ProductReview R
ON P.ProductID = R.ProductID


SELECT P.ProductNumber, R.Comments
	FROM Production.Product P 
		LEFT OUTER JOIN Production.ProductReview R
ON P.ProductID = R.ProductID
ORDER BY R.Comments DESC


SELECT P.ProductNumber, R.Comments
	FROM Production.Product P 
		RIGHT OUTER JOIN Production.ProductReview R
ON P.ProductID = R.ProductID


SELECT P.ProductNumber, R.Comments
	FROM Production.Product P 
		FULL OUTER JOIN Production.ProductReview R
ON P.ProductID = R.ProductID


SELECT P.ProductNumber, R.Comments
	FROM Production.Product P 
		CROSS JOIN Production.ProductReview R

SELECT  P.Name AS Product, L.Name AS Location, I.Quantity
	FROM Production.Product P 
		INNER JOIN Production.ProductInventory I 
	ON P.ProductID = I.ProductID
INNER JOIN Production.Location L 
	ON L.LocationID = I.LocationID


SELECT P1.Name, P1.ListPrice
FROM Production.Product AS P1
        INNER JOIN Production.Product AS P2
        ON P1.ProductSubcategoryID=P2.ProductSubcategoryID
GROUP BY P1.Name,P1.ListPrice
HAVING P1.ListPrice > AVG (P2.ListPrice)



SELECT  P.Name AS Product, V.Name AS Vendor, M.Name as Measure
FROM Production.Product P 
	INNER JOIN Purchasing.ProductVendor PV 
ON P.ProductID = PV.ProductID 
	INNER JOIN Purchasing.Vendor V 
ON PV.BusinessEntityID= V.BusinessEntityID
	INNER JOIN Production.UnitMeasure M 
ON M.UnitMeasureCode = PV.UnitMeasureCode


SELECT ProductModelID AS [Product ID], 
       ModifiedDate AS [Date of modification] 
	 FROM Production.ProductModelProductDescriptionCulture
UNION 
SELECT ProductModelID AS [Product ID], 
       ModifiedDate AS [Date of modification]
	 FROM Production.ProductModel


SELECT ProductModelID AS [Product ID], 
       ModifiedDate AS [Date of modification] 
	 FROM Production.ProductModelProductDescriptionCulture
EXCEPT 
SELECT ProductModelID AS [Product ID], 
       ModifiedDate AS [Date of modification]
	 FROM Production.ProductModel


SELECT ProductModelID AS [Product ID], 
       ModifiedDate AS [Date of modification] 
	 FROM Production.ProductModelProductDescriptionCulture
INTERSECT
SELECT ProductModelID AS [Product ID], 
    ModifiedDate AS [Date of modification]
    FROM Production.ProductModel


SELECT TOP 10 P.Name AS Product,L.Name AS Location, I.Quantity
FROM Production.Product P 
     INNER JOIN Production.ProductInventory I 
ON P.ProductID = I.ProductID
     INNER JOIN Production.Location L
ON L.LocationID = I.LocationID
ORDER BY I.Quantity ASC


SELECT Name as Product 
FROM Production.Product TABLESAMPLE (40 PERCENT)






