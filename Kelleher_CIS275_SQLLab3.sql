/*
CIS275, SQLLab 3 questions 
PCC using Microsoft SQL Server 2008
Marc Kelleher
11/20/15
date(s) for changes/enhancements/whatever
20120603 DUE DATE
*/

USE FiredUp    -- ensures correct database is active
GO
PRINT 'Remember that money is always formatted to two decimal places.
The answer file will show both implicit and explicit joining. Unless
requested otherwise you may use either.' + CHAR(10);

GO
PRINT 'CIS2275, Lab3, question 1, ten points possible.
Perform an inner join of the CUSTOMER table to the INVOICE table (CUSTOMER.CustomerID = INVOICE.FK_CustomerID).
Show, format and alias each column of both tables. Please concatenate City, StateProvince ZipCode, Country' + CHAR(10)
GO

SELECT	STR(C.CustomerID,8,0) AS 'Customer ID', 
		CAST(C.Name AS CHAR(50)) AS 'NAME', 
		CAST(C.StreetAddress AS CHAR(50)) AS 'Address',
		CAST(C.ApartmentNbr AS CHAR(10)) AS 'Apt. #',
		CAST (C.City + ', ' + C.StateProvince + ', '+ C.ZipCode + ', ' + C.Country AS CHAR(50)) AS 'City,State,Country',
		STR(I.InvoiceNbr,18,0) AS 'Invoice #',
		CONVERT(CHAR(12),I.InvoiceDt,101) AS 'Invoice Date',
		STR(I.TotalPrice,18,2) AS 'Total Price',
		STR(I.FK_EmpID,18,0) AS 'Employee ID'
FROM	CUSTOMER AS C JOIN INVOICE AS I ON C.CustomerID = I.FK_CustomerID
ORDER BY C.CustomerID ASC;

GO
PRINT 'CIS275, Lab3, question 2, ten points possible.
Perform an explicit full outer join of the CUSTOMER table to the INVOICE table. 
Display only the customer name, invoice number and invoice date.
SQL Server has no provision for implicit full outer joins.' + CHAR(10);
GO

SELECT	CAST(C.Name AS CHAR(50)) AS 'Customer Name', STR(I.InvoiceNbr,18,0) AS 'Invoice #', CONVERT(CHAR(12),I.InvoiceDt, 101) AS 'Invoice Date'
FROM	CUSTOMER AS C FULL OUTER JOIN INVOICE AS I 
		ON C.CustomerID = I.FK_CustomerID
ORDER BY InvoiceNbr ASC;

GO
PRINT 'CIS275, Lab3, question 3, ten points possible.
Join CUSTOMER table to INVOICE table to display customer name and invoice number 
for those customers with invoices. Restrict output to those customers having the 
last name of White. (Use LIKE keyword and wildcard)
Be careful: we don''t want to see Donna Penwhite in the output.' + CHAR(10);
GO

SELECT	STR(I.InvoiceNbr,18,0) AS 'Invoice #', CAST(C.Name AS CHAR(50)) AS 'Customer Name'
FROM	CUSTOMER AS C JOIN INVOICE AS I ON C.CustomerID = FK_CustomerID AND C.Name LIKE '% White%'
ORDER BY InvoiceNbr ASC; 

GO
PRINT 'CIS275, Lab3, question 4, ten points possible.
Include INV_LINE_ITEM to the join from previous question to add 
line number, quantity, FK_PartNbr and FK_StoveNbr to output.' + CHAR(10);
GO

SELECT	STR(I.InvoiceNbr,18,0) AS 'Invoice #', CAST(C.Name AS CHAR(50)) AS 'Customer Name', 
		STR(ILI.LineNbr,18,0) AS 'Line #', STR(ILI.Quantity,18,0) AS 'Quantity', 
		STR(ILI.FK_PartNbr,18,0) AS 'Part #', STR(ILI.FK_StoveNbr,18,0) AS 'Stove #'
FROM	CUSTOMER AS C JOIN INVOICE AS I ON (C.CustomerID = FK_CustomerID AND C.Name LIKE '% White%') 
		JOIN INV_LINE_ITEM AS ILI ON ILI.FK_InvoiceNbr = I.InvoiceNbr
ORDER BY InvoiceNbr ASC; 

GO
PRINT 'CIS275, Lab3, question 5, ten points possible.
Include STOVE table to join in previous question.
Display customer name, invoice number, serialnumber, and extended price.
Remove restriction on CUSTOMER last name of White.
Restrict output to only rows containing stoves.' + CHAR(10);
GO

SELECT	STR(I.InvoiceNbr,18,0) AS 'Invoice #', CAST(C.Name AS CHAR(50)) AS 'Customer Name', 
		STR(S.SerialNumber,18,0) AS 'Serial #', STR(ILI.ExtendedPrice,18,2) AS 'Ext. Price'
FROM	CUSTOMER AS C JOIN INVOICE AS I ON C.CustomerID = FK_CustomerID 
		JOIN INV_LINE_ITEM AS ILI ON ILI.FK_InvoiceNbr = I.InvoiceNbr 
		JOIN STOVE AS S ON S.SerialNumber = ILI.FK_StoveNbr
ORDER BY InvoiceNbr ASC;

GO
PRINT 'CIS2275, Lab3, question 6, ten points possible.
Project EMPLOYEE id and name, INVOICE number and total price using a LEFT OUTER JOIN
to show all employees whether they have sold anything or not.' + CHAR(10);
GO

SELECT	STR(E.EmpID,18,0) AS 'Employee ID', CAST(E.Name AS CHAR(50)) AS 'Employee Name', 
		STR(I.InvoiceNbr,18,0) AS 'Invoice #', STR(I.TotalPrice,18,2) AS 'Total Price'
FROM	EMPLOYEE AS E LEFT OUTER JOIN INVOICE AS I ON E.EmpID = I.FK_EmpID
ORDER BY E.EmpID ASC;

GO
PRINT 'CIS275, Lab3, question 7, ten points possible.
What is the average total price of invoices written by Fred Bailey? 
Display the number of invoices written by Fred
and the average total price of invoices.' + CHAR(10);
GO

SELECT	CAST(E.Name AS CHAR(50)) AS 'Employee Name', COUNT(I.InvoiceNbr) AS 'Inv Count', 
		STR(AVG(I.TotalPrice),8,2) AS 'Average Price'
FROM	INVOICE AS I INNER JOIN EMPLOYEE AS E ON E.EmpID = I.FK_EmpID AND E.Name LIKE 'Fred Bailey'
GROUP BY E.Name;

GO
PRINT 'CIS275, Lab3, question 8, ten points possible.
Display invoice number, invoice date, and stove number for all sold stoves. 
List in chronological order by invoice date.' + CHAR(10);
GO

SELECT	STR(I.InvoiceNbr,18,0) AS 'Invoice #', CONVERT(CHAR(12),I.InvoiceDt,101) AS 'Invoice Date',
		STR(ILI.FK_StoveNbr,18,0) AS 'Stove Number'
FROM	INVOICE AS I JOIN INV_LINE_ITEM AS ILI ON I.InvoiceNbr = ILI.FK_InvoiceNbr JOIN STOVE AS S ON S.SerialNumber = ILI.FK_StoveNbr
ORDER BY I.InvoiceDt ASC, I.InvoiceNbr ASC; 

GO
PRINT 'CIS275, Lab3, question 9, ten points possible.
Which stove invoices are in May of 2002? Display invoice number, 
invoice date, and stove number. Use BETWEEN to specify the date range 
and list in chronological order by invoice date.' + CHAR(10);
GO

SELECT	STR(I.InvoiceNbr,18,0) AS 'Invoice #', CONVERT(CHAR(12),I.InvoiceDt,101) AS 'Invoice Date',
		STR(ILI.FK_StoveNbr,18,0) AS 'Stove Number'
FROM	INVOICE AS I JOIN INV_LINE_ITEM AS ILI ON I.InvoiceNbr = ILI.FK_InvoiceNbr 
		JOIN STOVE AS S ON S.SerialNumber = ILI.FK_StoveNbr
WHERE	I.InvoiceDt BETWEEN '05/01/2002' AND '05/31/2002'
ORDER BY I.InvoiceDt ASC, I.InvoiceNbr ASC; 


GO
PRINT 'CIS275, Lab3, question 10, ten points possible.
Show the type and version with the count of the most repaired stove.
You will use the COUNT() aggregate function with a GROUP BY on type and version.' + CHAR(10);
GO

SET ROWCOUNT 1
SELECT	S.Type, S.Version, COUNT(SR.FK_StoveNbr) AS 'Times Repaired'
FROM	STOVE AS S JOIN STOVE_REPAIR AS SR ON S.SerialNumber = SR.FK_StoveNbr
GROUP BY S.Type, S.Version
ORDER BY 'Times Repaired' DESC;


GO
PRINT 'Extra and JUST FOR FUN (these queries are NOT required).' + CHAR(10);
GO
PRINT '(1) Project the invoice average total price, minimum total price, and maximum total price.';
GO

GO
PRINT '(2) Now project the same averages in one column.';
GO

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab3' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;
