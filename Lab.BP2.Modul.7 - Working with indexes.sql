--1 Creating table and indexes
CREATE DATABASE Test
GO

USE Test
GO

--First table does not have and primary key
CREATE TABLE Books
( BookID nvarchar(20) NOT NULL,
  PublisherID int NOT NULL,
  Title nvarchar(100) NOT NULL,
  ReleaseDate date NOT NULL
);

--Check the status od the object (notice it's a HEAP structure)
SELECT	schemaname = OBJECT_SCHEMA_NAME(o.object_id),
		tablename = o.name,
		i.index_id,
		i.type_desc
FROM sys.objects o
INNER JOIN sys.indexes i ON i.object_id = o.object_id
WHERE  o.type = 'U'
ORDER BY i.type_desc

ALTER TABLE Books
ADD CONSTRAINT PK_IX_BookID PRIMARY KEY CLUSTERED (BookID)
GO

--Check the status od the object (notice it's a CLUSTERED structure)
SELECT	schemaname = OBJECT_SCHEMA_NAME(o.object_id),
		tablename = o.name,
		i.index_id,
		i.type_desc
FROM sys.objects o
INNER JOIN sys.indexes i ON i.object_id = o.object_id
WHERE  o.type = 'U'
ORDER BY i.type_desc

--2 
/* Generate 100 000 records from pubs database using CROSS JOIN operator and inserting into Books table
   You should pay attention on correct data types
   If you don't have pubs sample database, download script instpubs.sql from same repository and execute it.
   Next step is requiring pubs database to generate similar Book related sample data
*/
INSERT INTO Books
SELECT TOP 100000
	   RIGHT (CAST (NEWID() AS nvarchar(36)),10),
	   t1.pub_id, 
	   t2.title, 
	   t2.pubdate
FROM pubs.dbo.titles AS t1
CROSS JOIN  pubs.dbo.titles AS t2
CROSS JOIN pubs.dbo.titleauthor AS t3
CROSS JOIN pubs.dbo.authors as t4

--3
-- Now turn on Actual Execution Plan on toolbar menu or press Ctrl+M and execute next statement
SELECT PublisherID
FROM Books
--Examine execution plan in results windows and notice that SQL Server use Clustered index on BookID to locate PublisherID and Title

--Now create Nonclusterd index on the column PublisherID
CREATE NONCLUSTERED INDEX IX_Book_Publisher
  ON dbo.Books (PublisherID);
GO

--Execute same query again and notice that SQL Server now use Nonclustered index on column PublisherID as better solution
SELECT PublisherID
FROM Books

--Drop previously created index
DROP INDEX IX_Book_Publisher
ON Books
GO

--Now create compisit Nonclusterd index on the columns PublisherID and ReleaseDate 
CREATE NONCLUSTERED INDEX IX_Book_Publisher_ReleaseDate
  ON dbo.Books (PublisherID, ReleaseDate DESC)
GO

--Execute query and examin execution plan and notice that SQL Server now use new Nonclustered index
SELECT PublisherID
FROM Books
WHERE ReleaseDate > DATEADD(year,-1,SYSDATETIME())

--Drop previously created index
DROP INDEX IX_Book_Publisher_ReleaseDate
ON Books
GO

--Now create composite Nonclusterd index on the columns PublisherID and ReleaseDate 
--and included column Title

CREATE NONCLUSTERED INDEX IX_Book_Publisher_ReleaseDate_Title
  ON dbo.Books (PublisherID, ReleaseDate DESC)
  INCLUDE (Title);
GO

--Execute query and examin execution plan and notice that SQL Server again use new Nonclustered index
SELECT PublisherID, Title, ReleaseDate
FROM dbo.Books 
WHERE ReleaseDate > DATEADD(year,-1,SYSDATETIME())
ORDER BY PublisherID, ReleaseDate DESC;
GO

--4
--Altering index
ALTER INDEX IX_Book_Publisher_ReleaseDate_Title ON dbo.Books
  DISABLE;
GO

ALTER INDEX IX_Book_Publisher_ReleaseDate_Title ON dbo.Book
  REBUILD;
GO

--5
--Examin index fragmentation in current database
DECLARE @db_id SMALLINT;
DECLARE @object_id INT;

SET @db_id = DB_ID(N'Test');
SET @object_id = OBJECT_ID(N'Test.dbo.Books');

SELECT * FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'LIMITED');
GO

--6
--Examine index information in all databases on connected SQL Server
SELECT * FROM sys.dm_db_index_physical_stats (NULL, NULL, NULL, NULL, NULL)
ORDER BY avg_fragmentation_in_percent DESC
GO