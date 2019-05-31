--1
/* Create local Windows login on your computer:
   Control Panel\All Control Panel Items\Administrative Tools\Computer Management\Local Users and Groups\Users
   RightClick\New User
*/


--2
/* Creating, Windows and SQL logins*/

--Windows login
--You will need your computer name: Right Click on My Computer\Computer name
CREATE LOGIN [X1\DataDude] --X1 is the name of computer and DataDude is local Windows login
FROM WINDOWS
WITH DEFAULT_DATABASE = AdventureWorks2014
GO

--Checking
SELECT name, dbname, password --notice password value null on Windows logins
FROM sys.syslogins
GO

-- SQL Server login
CREATE LOGIN Selver --local SQL Server login
WITH PASSWORD = 'S4mC001Pa$$w0rd'
GO

CREATE LOGIN Imran
WITH PASSWORD = 'password'
MUST_CHANGE, CHECK_EXPIRATION = ON
GO

/*
	Try to login in SQL Server with this two logins
	
	Before contionue with code you will need to reconect with your admin accouunt
*/

--Changing the login
ALTER LOGIN Selver 
WITH PASSWORD = 'S4mC001N3wPa$$w0rd'
GO

/*
	Mapping login as user on database
*/

-- Creating database user from login X1\DataDude
USE AdventureWorks2014
GO
CREATE USER DataDude FOR LOGIN [X1\DataDude]
GO

--Granting SELECT permission on a specific table

GRANT SELECT ON OBJECT::Person.Person TO DataDude 
GO 

--Cleaning environment
DROP USER DataDude
GO

DROP LOGIN [X1\DataDude]
GO
DROP LOGIN Imran
GO
DROP LOGIN Selver
GO


