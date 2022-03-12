--Tytu³: Raport z list¹ warunków szkodliwych pracowników
--Autor: Adam Bernaœ
--Update: 10-03-2022
--Version v1.1

/*Podgl¹d raportu
SELECT * FROM dbo.View_EmpHarmCond
*/
USE EmployeeMedicalTest
GO

--Usuñ widok je¿eli istnieje
IF OBJECT_ID ('dbo.View_EmpHarmCond') IS NOT NULL DROP VIEW dbo.View_EmpHarmCond
GO

--Tworzenie widoku z opcj¹ SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_EmpHarmCond
WITH SCHEMABINDING
AS

SELECT   
		E.Name											  as [Imiê i nazwisko],
		HC.Name											  as [Warunki szkodliwe],
		COUNT(*)OVER(PARTITION BY E.Name ORDER BY E.Name) as [Suma warunków szkodliwych]
FROM dbo.Employee				as E
JOIN dbo.EmployeeHarmCond		as EHC
	ON E.IdEmp = EHC.IdEmp
JOIN dbo.HarmfulConditions		as HC
	ON EHC.IdHC = HC.IdHC

WITH CHECK OPTION;