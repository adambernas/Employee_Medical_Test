--Tytu�: Raport z list� warunk�w szkodliwych pracownik�w
--Autor: Adam Berna�
--Update: 10-03-2022
--Version v1.1

/*Podgl�d raportu
SELECT * FROM dbo.View_EmpHarmCond
*/
USE EmployeeMedicalTest
GO

--Usu� widok je�eli istnieje
IF OBJECT_ID ('dbo.View_EmpHarmCond') IS NOT NULL DROP VIEW dbo.View_EmpHarmCond
GO

--Tworzenie widoku z opcj� SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_EmpHarmCond
WITH SCHEMABINDING
AS

SELECT   
		E.Name											  as [Imi� i nazwisko],
		HC.Name											  as [Warunki szkodliwe],
		COUNT(*)OVER(PARTITION BY E.Name ORDER BY E.Name) as [Suma warunk�w szkodliwych]
FROM dbo.Employee				as E
JOIN dbo.EmployeeHarmCond		as EHC
	ON E.IdEmp = EHC.IdEmp
JOIN dbo.HarmfulConditions		as HC
	ON EHC.IdHC = HC.IdHC

WITH CHECK OPTION;