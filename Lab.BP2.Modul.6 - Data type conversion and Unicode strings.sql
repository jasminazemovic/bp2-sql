--1

--Working with UNICODE strings
DECLARE @Hello nvarchar(20);

SET @Hello = N'Hello World';
SELECT @Hello
--Try to remove letter N on one place before string and then execute this code
SET @Hello = N'你好';
SELECT @Hello
SET @Hello = N'السلام عليكم';
SELECT @Hello

--Examples with CAST, CONVERT and PARSE functions
SELECT CAST(SYSDATETIME() AS nvarchar(30));

SELECT CAST(GETDATE() AS nvarchar(30));

SELECT CONVERT(nvarchar(30),SYSDATETIME(),113);

SELECT CONVERT(char(8), 0x4E616d65, 0) AS 'Binarni u tekstualni - stil 0';

SELECT PARSE('Monday, 06 May 2019' AS datetime2 USING 'en-US');
--Select each function CAST, CONVERT and PARS and then press F1 to open online help for additional information and examples

--2

--Diffrences between built in data/time SQL functions
SELECT SYSDATETIME(), SYSDATETIMEOFFSET(),SYSUTCDATETIME() ,CURRENT_TIMESTAMP,
       GETDATE(), GETUTCDATE()
GO