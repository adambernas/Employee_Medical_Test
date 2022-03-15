--Tytu³: Generowanie struktury bazy danych EmployeeMedicalTest z przyk³adowymi danymi
--Autor: Adam Bernaœ
--Update: 13-03-2022
--Wersia: 1.2

--Sprawdzanie czy baza danych ju¿ istnieje
IF EXISTS (SELECT name FROM sys.databases WHERE name='EmployeeMedicalTest ')  
DROP DATABASE EmployeeMedicalTest 
GO
--Tworzenie i korzystanie z bazy danych "EmployeeMedicalTest "
CREATE DATABASE EmployeeMedicalTest 
GO
USE EmployeeMedicalTest 
GO
SET NOCOUNT ON

--Tworzenie tabeli Tests
CREATE TABLE dbo.Tests
(	IdTest INT NOT NULL 
		CONSTRAINT PK_Tests PRIMARY KEY,
	Name NVARCHAR(60) NOT NULL,
	Price MONEY	NOT NULL 
		CONSTRAINT CH_Tests_TestPrice CHECK(Price >=0)
)
GO
--Tworzenie tabeli HarmfulConditions
CREATE TABLE dbo.HarmfulConditions
(	IdHC INT NOT NULL
		CONSTRAINT PK_HarmfulConditions PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL
)
GO
--Tworzenie tabeli Workplace
CREATE TABLE dbo.Workplace
(	IdWork INT NOT NULL
		CONSTRAINT PK_Workplace PRIMARY KEY,
	Name NVARCHAR(30) NOT NULL
)
GO
--Tworzenie tabeli Employee
CREATE TABLE dbo.Employee
(	IdEmp INT NOT NULL
		CONSTRAINT PK_Employee PRIMARY KEY,
	Name NVARCHAR(30) NOT NULL
)
GO
--Tworzenie tabeli EmployeeWorkplace
CREATE TABLE dbo.EmployeeWorkplace		
(	IdEW INT NOT NULL IDENTITY
		CONSTRAINT PK_EmployeeWorkplace PRIMARY KEY,
	IdEmp INT NOT NULL,
	IdWork INT NOT NULL
)
GO
--Tworzenie tabeli WorkplaceHarmCond
CREATE TABLE dbo.WorkplaceHarmCond		
(	IdWHC INT NOT NULL IDENTITY
		CONSTRAINT PK_WorkplaceHarmCond PRIMARY KEY,
	IdWork INT NOT NULL,
	IdHC INT NOT NULL
)
GO
--Tworzenie tabeli HarmCondTests
CREATE TABLE dbo.HarmCondTests
(	IdHCT INT NOT NULL IDENTITY
		CONSTRAINT PK_HarmCond_Tests PRIMARY KEY,
	IdHC INT NOT NULL,
	IdTest INT NOT NULL
)
GO
--Wprowadzanie danych do tabeli Tests
INSERT INTO dbo.Tests(IdTest, Name, Price) VALUES
(1, 'Lekarz medycyny pracy', 180),
(2, 'Lekarz medycyny pracy z uprawnieniami', 140),
(3, 'Konsultacja okulistyczna', 150),
(4, 'Konsultacja neurologiczna', 135),
(5, 'Konsultacja laryngologiczna', 130),
(6, 'EKG', 65),
(7, 'Glukoza', 15),
(8, 'Psychotechnika', 100),
(9, 'Nyktometria', 50),
(10, 'Cholesterol ca³kowity', 10),
(11, 'Spirometria', 45),
(12, 'ALT', 35),
(13, 'Bilirubina ca³kowita', 20),
(14, 'Morfologia', 30),
(15, 'RTG klatka piersiowa', 40)

--Wprowadzanie danych do tabeli HarmfulConditions
INSERT INTO HarmfulConditions(IdHC, Name) VALUES
(1, 'Amioniak'),
(2, 'Detergenty, Œrodki Czystoœci (Dezynfekuj¹ce),'),
(3, 'DŸwiganie'),
(4, 'Freony'),
(5, 'Kierowanie Pojazdem S³u¿bowym Kat. B'),
(6, 'Konkurs Na Kierownika'),
(7, 'Konkurs Na Dyrektora'),
(8, 'Maszyna Z Ruchomymi Czêœciami W Os³onach'),
(9, 'Maszyna Z Ruchomymi Czêœciami Bez Os³on'),
(10, 'Mikroklimat Gor¹cy'),
(11, 'Mikroklimat Zmienny'),
(12, 'Mikroklimat Zimny'),
(13, 'Monitor Poni¿ej, Powy¿ej, Równo 4H'),
(14, 'Nara¿enie ¯ycia, Stres, Decyzyjnoœæ'),
(15, 'Nitro (Rozpuszczalniki),'),
(16, 'Odpowiedzialnoœæ Finansowa'),
(17, 'Praca Fizyczna (DŸwiganie Ciê¿arów), - Lekka'),
(18, 'Praca Fizyczna (DŸwiganie Ciê¿arów), - Œrednio Ciê¿ka / Ciê¿ka / Bez Okreœlenia Jaka'),
(19, 'Praca Na Wysokoœci Do 3M'),
(20, 'Praca Na Wysokoœci Powy¿ej 3M'),
(21, 'Praca Stresogenna (Stres, Sta³y Dop³yw Informacji, Decyzyjnoœæ),'),
(22, 'Praca Z Narzêdziami Rêcznymi'),
(23, 'Pr¹d'),
(24, 'Propan'),
(25, 'Spawanie Gazowe'),
(26, 'Stanowisko Decyzyjne'),
(27, 'Wózek Wid³owy, Unosz¹cy, Drogowy, Jezdniowy Powy¿ej 1,6M'),
(28, 'Wózek Elektryczny'),
(29, 'Wysokoœæ Poni¿ej 3M'),
(30, 'Wysokoœæ Powy¿ej 3M'),
(31, 'Zagro¿enie Wynikaj¹ce Ze Sta³ego Du¿ego Dop³ywu Informacji I Gotowoœæ Do Odpowiedzi')

--Wprowadzanie danych do tabeli Workplace
INSERT INTO dbo.Workplace(IdWork, Name) VALUES
(1, 'Kierownik'),
(2, 'Sekretarka'),
(3, 'Spawacz'),
(4, 'Magazynier'),
(5, 'Sprzedawca'),
(6, 'Monter'),
(7, 'Elektryk')

--Wprowadzanie danych do tabeli Employee
INSERT INTO dbo.Employee(IdEmp, Name) VALUES
(1, 'Jan Kowalski'),
(2, 'Sebastian Bartniczak'),
(3, 'Wojtek Wojarek'),
(4, 'Marek Misiunia'),
(5, 'Adam Bystry'),
(6, 'Kamil Kania'),
(7, '£ukasz Mikula'),
(8, 'Mariusz Psikuta'),
(9, 'Marcin Adamowicz'),
(10, 'Kamila Nowak')

--Wprowadzanie danych do tabeli EmployeeWorkplace
SET IDENTITY_INSERT dbo.EmployeeWorkplace ON
INSERT INTO dbo.EmployeeWorkplace(IdEW, IdEmp, IdWork) VALUES
(1, 1, 1),
(2, 2, 3),
(3, 3, 4),
(4, 4, 5),
(5, 5, 1),
(6, 6, 5),
(7, 7, 6),
(8, 8, 7),
(9, 9, 4),
(10, 10, 2)
SET IDENTITY_INSERT dbo.EmployeeWorkplace OFF

--Wprowadzanie danych do tabeli EmployeeHarmCond
SET IDENTITY_INSERT dbo.WorkplaceHarmCond ON
INSERT INTO dbo.WorkplaceHarmCond(IdWHC, IdWork, IdHC) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 2, 1),
(6, 2, 3),
(7, 2, 5),
(8, 2, 6),
(9, 2, 15),
(10, 3, 5),
(11, 3, 13),
(12, 3, 25),
(13, 4, 2),
(14, 4, 8),
(15, 4, 9),
(16, 4, 15),
(22, 5, 13),
(23, 5, 4),
(24, 6, 13),
(25, 6, 9),
(26, 6, 6),
(27, 7, 5),
(28, 7, 13),
(29, 7, 20),
(30, 7, 23),
(31, 7, 30)
SET IDENTITY_INSERT dbo.WorkplaceHarmCond OFF

--Wprowadzanie danych do tabeli HarmCondTests
SET IDENTITY_INSERT dbo.HarmCondTests ON
INSERT INTO dbo.HarmCondTests(IdHCT, IdHC, IdTest) VALUES
(1, 1, 1),
(2, 1, 11),
(3, 2, 1),
(4, 2, 3),
(5, 2, 4),
(6, 3, 1),
(7, 3, 6),
(8, 4, 1),
(9, 4, 11),
(10, 5, 1),
(11, 5, 3),
(12, 5, 4),
(13, 5, 7),
(14, 5, 8),
(15, 6, 1),
(16, 6, 6),
(17, 6, 10),
(18, 7, 1),
(19, 7, 6),
(20, 7, 10),
(21, 8, 1),
(22, 8, 3),
(23, 9, 1),
(24, 9, 3),
(25, 9, 4),
(26, 9, 8),
(27, 10, 1),
(28, 10, 6),
(29, 11, 1),
(30, 11, 6),
(31, 12, 1),
(32, 12, 3),
(33, 13, 1),
(34, 13, 3),
(35, 14, 1),
(36, 14, 6),
(37, 14, 10),
(38, 15, 1),
(39, 15, 4),
(40, 15, 12),
(41, 15, 13),
(42, 15, 14),
(43, 16, 1),
(44, 16, 6),
(45, 16, 10),
(46, 17, 1),
(47, 17, 6),
(48, 17, 8),
(49, 18, 1),
(50, 18, 6),
(51, 19, 1),
(52, 19, 3),
(53, 20, 1),
(54, 20, 3),
(55, 20, 4),
(56, 20, 5),
(57, 21, 1),
(58, 21, 6),
(59, 21, 10),
(60, 22, 1),
(61, 22, 3),
(62, 23, 1),
(63, 23, 3),
(64, 24, 1),
(65, 24, 7),
(66, 25, 1),
(67, 25, 3),
(68, 25, 11),
(69, 25, 15),
(70, 26, 1),
(71, 26, 6),
(72, 26, 10),
(73, 27, 1),
(74, 27, 3),
(75, 27, 4),
(76, 27, 5),
(77, 27, 8),
(78, 28, 1),
(79, 28, 3),
(80, 28, 4),
(81, 28, 8),
(82, 29, 1),
(83, 29, 3),
(84, 30, 1),
(85, 30, 3),
(86, 30, 4),
(87, 30, 5),
(88, 31, 1),
(89, 31, 6),
(90, 31, 10)
SET IDENTITY_INSERT dbo.HarmCondTests OFF

--Tworzenie kluczy obcych do tabel
ALTER TABLE dbo.EmployeeWorkplace
	ADD CONSTRAINT FK_EmployeeWorkplace_Employee
	FOREIGN KEY(IdEmp) REFERENCES dbo.Employee(IdEmp)
	ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE dbo.EmployeeWorkplace
	ADD CONSTRAINT FK_EmployeeWorkplace_Workplace
	FOREIGN KEY(IdWork) REFERENCES dbo.Workplace(IdWork)
	ON UPDATE CASCADE
GO
ALTER TABLE dbo.WorkplaceHarmCond
	ADD CONSTRAINT FK_WorkplaceHarmCond_Workplace 
	FOREIGN KEY(IdWork) REFERENCES dbo.Workplace(IdWork)
	ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE dbo.WorkplaceHarmCond
	ADD CONSTRAINT FK_WorkplaceHarmCond_HarmfulConditions 
	FOREIGN KEY(IdHC) REFERENCES dbo.HarmfulConditions(IdHC)
	ON DELETE CASCADE ON UPDATE CASCADE 
GO
ALTER TABLE dbo.HarmCondTests
	ADD CONSTRAINT FK_HarmCondTests_HarmfulConditions
	FOREIGN KEY(IdHC) REFERENCES dbo.HarmfulConditions(IdHC)
	ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE dbo.HarmCondTests
	ADD CONSTRAINT FK_HarmCondTests_Tests
	FOREIGN KEY(IdTest) REFERENCES dbo.Tests(IdTest)
	ON UPDATE CASCADE