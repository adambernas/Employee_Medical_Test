--Tytuł: Lista warunków szkodliwych na nadym stanowisku
--Autor: Adam Bernaś
--Update: 14-03-2022
--Version v1.2

/*Podgląd raportu
SELECT * FROM dbo.View_WorkHarmCond
*/
USE EmployeeMedicalTest
GO

--Usuń widok jeżeli istnieje
IF OBJECT_ID ('dbo.View_WorkHarmCond') IS NOT NULL DROP VIEW dbo.View_WorkHarmCond
GO

--Tworzenie widoku z opcją SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_WorkHarmCond
WITH SCHEMABINDING
AS

SELECT
	   W.Name	 as Stanowisko,
	   HC.Name	 as [Warunki szkodliwe],
	   COUNT(*)OVER(PARTITION BY W.Name ORDER BY W.Name) as [Liczba warunków szkodliwych]
FROM dbo.Workplace as W
JOIN dbo.WorkplaceHarmCond as WHC
	ON W.IdWork = WHC.IdWork
JOIN dbo.HarmfulConditions as HC
	ON WHC.IdHC = HC.IdHC

WITH CHECK OPTION;