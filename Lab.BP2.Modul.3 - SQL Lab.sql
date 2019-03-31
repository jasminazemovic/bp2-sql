/*
1. Koristeci tabele 
CountryRegion, 
StateProvince i 
Address 
iz baze podataka AdwentureWorks2014 napraviti izvjestaj koji za svaku drzavu prikazuje: 
sve njene regione i 
broj osoba unutar svakog regiona 
*/


USE AdventureWorks2014
GO
SELECT     CR.Name AS Region, SP.Name AS Drzava, COUNT (PA.StateProvinceID) AS Ukupno
FROM         Person.CountryRegion  AS CR INNER JOIN Person.StateProvince AS SP 
			 ON CR.CountryRegionCode = SP.CountryRegionCode 
					INNER JOIN Person.Address AS PA 
						ON SP.StateProvinceID = PA.StateProvinceID
GROUP BY  CR.Name, SP.Name
ORDER BY CR.Name


/* 
2. Iz baze podataka pubs prikazati 
spojeno prezime i ime autora 
ukupan brojem objavljenih djela za svakog autora
kolone prikazati u formatu razumljivom krajnjem korisniku. 
Izlaz poredati abecedno po prezimenu
*/

USE pubs
GO
SELECT     A.au_lname + ' ' + A.au_fname AS 'Ime i prezime', COUNT (T.title_id) AS Ukupno
FROM         authors AS A INNER JOIN titleauthor AS TA 
							ON A.au_id = TA.au_id INNER JOIN  titles AS T
													ON TA.title_id = T.title_id
GROUP BY A.au_lname,A.au_fname
ORDER BY A.au_lname


/* 
3. Iz baze podataka Northwind prikazati
listu proizvoda sa imenom i cijenom po komadu. 

Takodjer izlaz treba da sadrzi:
ukupan broj komada svakog proizvoda u magacinu, 
i ukupnu prodaju za svaki proizvod
*/

USE Northwind
GO
SELECT     P.ProductName, P.UnitPrice, SUM (P.UnitsInStock) AS 'Zalihe', COUNT (OD.ProductID) AS 'Prodato'
FROM       Products AS P INNER JOIN [Order Details] AS OD
										ON P.ProductID = OD.ProductID
GROUP BY P.ProductName, P.UnitPrice
ORDER BY P.ProductName

/* 
4. Koristeci bazu Northwind prikazati
 za svaku drzavu ime grada,
ime kompanije  i ukupan broj narudzbi te iste kompanije
*/

USE Northwind
GO
SELECT C.Country, C.City, C.CompanyName, COUNT (OrderID) AS "Ukupno narud�bi"
FROM Customers AS C INNER JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
GROUP BY Country, City, CompanyName

/*
5. DBA junior u Vasoj kompaniji je prijavio da postoji greska u podacima 
ili SQL Server grijesi u procesiranju upita. Nekada je izlaz vise, a nekada 
niti jedan zapis. DBA sigurno zna da tabela ProductModelProductDescriptionCulture
 imam preko 700 zapisa. Samim time 50% je okvirno 350 zapisa.
*/

USE AdventureWorks2014
GO

SELECT TOP (300) ProductModelID AS [Product ID], 
       ModifiedDate AS [Date of modification] 
	 FROM Production.ProductModelProductDescriptionCulture 
	 TABLESAMPLE(50 PERCENT)
INTERSECT
SELECT TOP (60) ProductModelID AS [Product ID], 
    ModifiedDate AS [Date of modification]
    FROM Production.ProductModel 
    TABLESAMPLE(50 PERCENT)

/* Koristeci bazu podataka AdwentureWorksLT napraviti upit koji daje sljedeci rezultat:
	Sastavljeno ime i prezime kupca, grad iz kojeg dolazi kupac, datum narudzbe, 
	broj narudzbe, kolicinu narudzbe i ime kupljenog proizvoda*/

USE AdventureWorksLT
SELECT  C.FirstName + ' ' + C.LastName AS 'Ime i prezime'
		,A.City
		,SOH.OrderDate
		,SOH.SalesOrderID
		,SOD.OrderQty
		,P.Name
FROM    SalesLT.Customer AS C INNER JOIN 
        SalesLT.CustomerAddress AS CA ON C.CustomerID = CA.CustomerID INNER JOIN
        SalesLT.Address AS A ON CA.AddressID = A.AddressID INNER JOIN
        SalesLT.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID INNER JOIN
        SalesLT.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID INNER JOIN
        SalesLT.Product AS P ON SOD.ProductID = P.ProductID
ORDER BY C.FirstName


/* Isti primjer ali bez koristenja ALIASA, razlika je i vise nego ocigledna*/
USE AdventureWorksLT
SELECT  SalesLT.Customer.FirstName + ' ' + SalesLT.Customer.LastName AS 'Ime i prezime'
		,SalesLT.Address.City
		,SalesLT.SalesOrderHeader.OrderDate
		,SalesLT.SalesOrderHeader.SalesOrderID
		,SalesLT.SalesOrderDetail.OrderQty
		,SalesLT.Product.Name
FROM    SalesLT.Customer INNER JOIN
        SalesLT.CustomerAddress ON SalesLT.Customer.CustomerID = SalesLT.CustomerAddress.CustomerID INNER JOIN
        SalesLT.Address ON SalesLT.CustomerAddress.AddressID = SalesLT.Address.AddressID INNER JOIN
        SalesLT.SalesOrderHeader ON SalesLT.Customer.CustomerID = SalesLT.SalesOrderHeader.CustomerID INNER JOIN
        SalesLT.SalesOrderDetail ON SalesLT.SalesOrderHeader.SalesOrderID = SalesLT.SalesOrderDetail.SalesOrderID INNER JOIN
        SalesLT.Product ON SalesLT.SalesOrderDetail.ProductID = SalesLT.Product.ProductID
ORDER BY SalesLT.Customer.FirstName