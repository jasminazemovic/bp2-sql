--1

--Check default location od DATA and LOG files on SQL Server instance
USE master
GO
SELECT
  SERVERPROPERTY('InstanceDefaultDataPath') AS 'Data Files',
  SERVERPROPERTY('InstanceDefaultLogPath') AS 'Log Files'

--or you can check file names and location of all DATA and LOG files
USE master;
SELECT  name AS 'Database name',  physical_name  AS 'File Location'
FROM sys.master_files;

--2

--Default location from step 1 can be used in the process of creating database with custom settings
--in my case it's default path and default generic name 
--...\MSSQL14.MSSQLSERVER\... means that I have SQL Server 2017
--Check your SQL Server version
SELECT @@VERSION
GO

--Create new database with custom user defined settings
USE master
GO

CREATE DATABASE Prodaja
ON
  (NAME = Prodaja_dat, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Prodaja.mdf', 
	SIZE = 100MB, MAXSIZE = 500MB, FILEGROWTH = 20% )
LOG ON
  (NAME = Prodaja_log, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Prodaja.ldf', 
	SIZE = 20MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10MB );
GO

--Check is your database listed
SELECT * FROM sys.databases
GO

--Delete database Prodaja
DROP DATABASE Prodaja
GO

--Create database Prodaja but this time with default SQL Server settings
CREATE DATABASE Prodaja
GO

--Information about database Prodaja
USE Prodaja
GO
SELECT * FROM sys.database_files

--3

--Create new table in database Prodaja
USE Prodaja
GO

CREATE TABLE Kupci
( KupacID int IDENTITY(1,1),
  Prezime nvarchar(30) NOT NULL,
  Ime nvarchar(30) NOT NULL, 
  Telefon nvarchar (30) NULL
);

--Check is your table listed
SELECT object_id, name, type_desc, create_date
FROM sys.tables

--You can see all columns form specific table with this system view
--NOTE: from the query result of previous step copy value object_id in the row related for the table Kupci and paste it in WHERE clause
SELECT *
FROM sys.columns
WHERE object_id = 901578250

--Adding new column and checking
ALTER TABLE Kupci
ADD Email nvarchar(100) NOT NULL;
GO

SELECT *
FROM sys.columns
WHERE object_id = 901578250
GO

--Droping a column
ALTER TABLE Kupci
DROP COLUMN Telefon;
GO

--3

--Creating an alias type based on the nvarchar data type
CREATE TYPE Kod 
FROM nvarchar(20) NOT NULL;
GO

--Using an aliac type in DDL definition of table
CREATE TABLE Narudzbe
(	NarudzbaID int IDENTITY(1,1),
	ArtikalID int,
	BarKod Kod --an alias type
);

--Creating local temp table only visible in current session (user)
CREATE TABLE #tempTransakcije
( TranskacijaID int PRIMARY KEY,
  Opis nvarchar (100)
);
GO

--Check #tempTransakcije
USE tempdb
GO

SELECT object_id, name, schema_id, type_desc, create_date
FROM sys.tables

--Inserting one record and checking it
INSERT INTO #tempTransakcije
VALUES (1, 'Online kupovina')
GO

SELECT * 
FROM #tempTransakcije
GO

--Open new query windows and copy SELECT * FROM #tempTransakcije and execute the statement
--It will throw an error because new session trying access to temp table

--4

--Cleaning test environment
DROP TABLE #tempTransakcije
GO

USE Prodaja
GO

DROP TABLE Kupci
GO

DROP TABLE Narudzbe
GO

DROP TYPE Kod
GO

--5

--Creating two tables Gradovi and Kupci with referential integrity constraint between them 

CREATE TABLE Gradovi
( GradID int IDENTITY(1,1) CONSTRAINT PK_Grad PRIMARY KEY,
  Naziv nvarchar(100)
)
GO

CREATE TABLE Kupci
( KupacID int IDENTITY(1,1) CONSTRAINT PK_Kupac PRIMARY KEY,
  Prezime nvarchar(30) NOT NULL,
  Ime nvarchar(30) NOT NULL, 
  Telefon nvarchar (30) NULL,
  Email nvarchar (100) NOT NULL CONSTRAINT UQ_Email UNIQUE, --Unique constraint on Email
  DatumRodjenja date NOT NULL,
  GradID int NOT NULL CONSTRAINT FK_Kupac_Gradovi FOREIGN KEY REFERENCES Gradovi (GradID),
  GodinaRodjenja AS DATEPART (year, DatumRodjenja) PERSISTED --Calculated column
);


--Check your tables
SELECT object_id, name, type_desc, create_date
FROM sys.tables

--Cleaning test environment
USE master
GO

DROP DATABASE Prodaja
GO