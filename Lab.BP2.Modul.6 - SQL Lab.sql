--1 Review the requirements for a table design: 
/*
a) Table called JobCandidates
b) Columns and requirements are:

 - JobCandidateID (identifies the row)
 - FirstName (unicode support)
 - LastName (unicode support)
 - CountryCode   (used to hold a 3 letter code)
 - StateOrRegion (used to hold details of a state or region 
				 if the countrycode is BiH, this must be 3 characters long)
 - DateOfBirth (not date of data entry or future)
 - PossibilityOfJoining (value from 1 to 5)
			with 5 being most likely but 3 as the default if not specified)

 What constraints should be put in place?
*/

CREATE DATABASE Test
GO

USE Test
GO

CREATE TABLE JobCandidates
(
	JobCandidateID int NOT NULL,
	FirstName nvarchar(30) NOT NULL,
	LastName nvarchar(30) NULL,
	CountryCode nchar(3) NOT NULL
		  CONSTRAINT CHK_CountryCode_Length3
		  CHECK (LEN(CountryCode) = 3),
	StateOrRegion nvarchar(20) NULL,
		CONSTRAINT CHK_BiH_States_Length2
		CHECK (CountryCode <> N'BiH' OR 
				LEN(StateOrRegion) = 3),
	DateOfBirth date NOT NULL
		  CONSTRAINT CHK_DateOfBirth_NotFuture
		  CHECK (DateOfBirth < GETDATE()),
	PossibilityOfJoining int NOT NULL
		CONSTRAINT CHK_PossibilityOfJoining_Range1To5
		CHECK (PossibilityOfJoining BETWEEN 1 AND 5)
		CONSTRAINT DF_PossibilityOfJoining DEFAULT (3)
);
GO

--2 Execute statements to test integrity constraints

-- INSERT a row providing all values ok:

INSERT INTO dbo.JobCandidates 
  ( JobCandidateID, FirstName, LastName, CountryCode, 
	StateOrRegion, DateOfBirth, PossibilityOfJoining)
  VALUES (1, 'Jon','Smith','BiH', 'HNK', '19730402', 4);
GO

SELECT * FROM dbo.JobCandidates;
GO

-- INSERT a row that fails the country code length test

INSERT INTO dbo.JobCandidates 
  ( JobCandidateID, FirstName, LastName, CountryCode, 
	StateOrRegion, DateOfBirth, PossibilityOfJoining)
  VALUES (2, 'Joana','Smith', 'UK', 'Essex', '19730405', 2);
GO

-- INSERT a row that fails the date of birth test

INSERT INTO dbo.JobCandidates 
  ( JobCandidateID, FirstName, LastName, CountryCode, 
	StateOrRegion, DateOfBirth, PossibilityOfJoining)
  VALUES (3, 'John','Doe', 'BiH', 'ZDK', '20600405', 2);
GO

-- INSERT a row that fails the BiH State length test

INSERT INTO dbo.JobCandidates 
  ( JobCandidateID, FirstName, LastName, CountryCode, 
	StateOrRegion, DateOfBirth, PossibilityOfJoining)
  VALUES (4, 'Johnana','Doe', 'BiH', 'Ze-do', '19780405', 2);
GO

--  Query sys.sysconstraints to see the list of constraints

SELECT OBJECT_NAME(id) AS TableName,
       OBJECT_NAME(constid) AS ConstraintName,
       * 
FROM sys.sysconstraints;
GO

DROP TABLE JobCandidates
GO

--3 Create the Customer and CustomerOrder tables and populate them

use Test
GO

--Check are the tables already exists in the database
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerOrder' AND schema_id=1)
DROP Table CustomerOrder
GO

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Customer' AND schema_id=1)
DROP TABLE dbo.Customer
GO

CREATE TABLE dbo.Customer
(
	CustomerID int IDENTITY(1,1) PRIMARY KEY,
	CustomerName nvarchar(50) NOT NULL
);
GO

INSERT dbo.Customer
  VALUES ('John Smith'),('Johnana Smith');
GO

CREATE TABLE dbo.CustomerOrder
(
	CustomerOrderID int IDENTITY(1,1) PRIMARY KEY,
	CustomerID int NOT NULL
	  FOREIGN KEY REFERENCES dbo.Customer (CustomerID),
	OrderAmount decimal(18,2) NOT NULL
);
GO

-- Select the list of customers and perform insert into the CustomerOrder table

SELECT * FROM dbo.Customer;
GO

INSERT INTO dbo.CustomerOrder (CustomerID, OrderAmount)
  VALUES (1, 12.50), (2, 14.70),
		 (1, 18.50), (2, 19.70),
		 (1, 100.50),(2, 56.70);
GO

--Notice that ID (PK - IDENTITY) values are repating in this two tables
SELECT * FROM dbo.Customer;
GO
SELECT * FROM dbo.CustomerOrder;
GO

-- Drop the tables
DROP TABLE CustomerOrder
GO
DROP TABLE Customer
GO

-- 4 Create a sequence database object to use with Customers and CustomerOrder tables

CREATE SEQUENCE GlobalDatabaseID AS INT
  START WITH 1001
  INCREMENT BY 1;
GO

-- Recreate the tables Customers and CustomerOrder using the sequence for default values

CREATE TABLE dbo.Customer
(
	CustomerID int PRIMARY KEY
	CONSTRAINT DF_CustomerID DEFAULT (NEXT VALUE FOR GlobalDatabaseID),
   	CustomerName nvarchar(50) NOT NULL
);
GO

INSERT dbo.Customer (CustomerName)
  VALUES ('John Smith'),('Johnana Smith');
GO

CREATE TABLE dbo.CustomerOrder
(
	CustomerOrderID int PRIMARY KEY
	CONSTRAINT DF_CustomerOrderID DEFAULT (NEXT VALUE FOR GlobalDatabaseID),
	CustomerID int NOT NULL
	  FOREIGN KEY REFERENCES dbo.Customer (CustomerID),
	OrderAmount decimal(18,2) NOT NULL
);
GO

INSERT INTO dbo.CustomerOrder (CustomerID, OrderAmount)
  VALUES (1001, 12.50), (1002, 14.70),
		 (1001, 18.50), (1002, 19.70),
		 (1001, 100.50),(1002, 56.70);
GO

SELECT * FROM dbo.Customer;
GO

INSERT INTO dbo.CustomerOrder (CustomerID, OrderAmount)
  VALUES (1, 12.50), (2, 14.70),
		 (1, 18.50), (2, 19.70),
		 (1, 100.50),(2, 56.70);
GO

--Notice that ID (PK) values are now diffrent in this two tables
SELECT * FROM dbo.Customer;
GO
SELECT * FROM dbo.CustomerOrder;
GO

--5 Clean testing environment
DROP TABLE CustomerOrder
GO
DROP TABLE Customer
GO
DROP SEQUENCE GlobalDatabaseID
GO
USE master
GO
DROP DATABASE Test
GO