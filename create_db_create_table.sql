-- @license: GPLv2
-- @author: luxfinis
-- @source: github/luxfinis

CREATE DATABASE [Library]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Library', FILENAME = N's:\program\Microsoft SQL Server\MSSQL11.SQLEXPRESSSERVER\MSSQL\DATA\Library.mdf' , SIZE = 5120KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Library_log', FILENAME = N's:\program\Microsoft SQL Server\MSSQL11.SQLEXPRESSSERVER\MSSQL\DATA\Library_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Library] SET COMPATIBILITY_LEVEL = 110
GO
ALTER DATABASE [Library] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Library] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Library] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Library] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Library] SET ARITHABORT OFF 
GO
ALTER DATABASE [Library] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Library] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Library] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Library] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Library] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Library] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Library] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Library] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Library] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Library] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Library] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Library] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Library] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Library] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Library] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Library] SET  READ_WRITE 
GO
ALTER DATABASE [Library] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Library] SET  MULTI_USER 
GO
ALTER DATABASE [Library] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Library] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Library]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [Library] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

USE[Library]
GO
CREATE TABLE Fachgebiete
(
	p_fachgebiet_id INTEGER NOT NULL PRIMARY KEY,
	name NVARCHAR(MAX) NOT NULL,
	kuerzel CHAR(4) NOT NULL UNIQUE,
)

USE[Library]
GO
CREATE TABLE Autoren
(
	p_autor_id INTEGER NOT NULL PRIMARY KEY,
	vorname NVARCHAR(MAX) NOT NULL,
	name NVARCHAR(MAX) NOT NULL,
)

USE[Library]
GO
CREATE TABLE Bibliotheken
(
	p_bibliothek_id INTEGER NOT NULL PRIMARY KEY,
	name NVARCHAR(MAX) NOT NULL,
	ort NVARCHAR(MAX) NOT NULL,
	gebuehren_jahr SMALLINT NOT NULL DEFAULT 500,
	gebuehren_leihfrist SMALLINT NOT NULL DEFAULT 500,
	leihfrist_wochen TINYINT,
)

USE[Library]
GO
CREATE TABLE Oeffnungszeiten
(
	p_wochentag CHAR(3),
	von TIME,
	bis TIME,
	pf_bibliothek_id INTEGER NOT NULL FOREIGN KEY REFERENCES Bibliotheken(p_bibliothek_id) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (p_wochentag, pf_bibliothek_id),
)

USE[Library]
GO
CREATE TABLE Nutzer
(
	p_personen_id INTEGER NOT NULL PRIMARY KEY,
	mitarbeiter BIT NOT NULL,
	vorname NVARCHAR(MAX) NOT NULL,
	name NVARCHAR(MAX) NOT NULL,
	geburtsdatum DATE NOT NULL,
	kontostand SMALLINT NOT NULL DEFAULT 0,
)

USE[Library]
GO
CREATE TABLE Ausweise
(
	pf_personen_id INTEGER NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES NUTZER(p_personen_id) ON UPDATE CASCADE ON DELETE CASCADE,
	ausweisnr INTEGER NOT NULL UNIQUE,
	passwort VARCHAR(16) NOT NULL,
	gueltigBis DATE NOT NULL,
	gesperrt BIT NOT NULL,
)

USE[Library]
GO
CREATE TABLE Buecher
(
	p_ISBN BIGINT NOT NULL PRIMARY KEY,
	titel NVARCHAR(MAX) NOT NULL,
	f_fachgebiet_id INTEGER FOREIGN KEY REFERENCES Fachgebiete(p_fachgebiet_id) ON UPDATE CASCADE,
)

USE[Library]
GO
CREATE TABLE Exemplare
(
	p_signatur VARCHAR(10) PRIMARY KEY,
	f_ISBN BIGINT NOT NULL FOREIGN KEY REFERENCES Buecher(p_ISBN) ON UPDATE CASCADE,
)

USE[Library]
GO
CREATE TABLE Ausgeliehene_Exemplare
(
	pf_signatur VARCHAR(10) FOREIGN KEY REFERENCES Exemplare(p_signatur) ON UPDATE CASCADE,
	pf_personen_id INTEGER FOREIGN KEY REFERENCES Nutzer(p_personen_id) ON UPDATE CASCADE,
	rueckgabe_datum DATE NOT NULL,
	anzahl_verlaengerungen TINYINT,
	PRIMARY KEY (pf_signatur, pf_personen_id)
)

USE[Library] 
GO
CREATE TABLE Vorbestellte_Buecher
(
	pf_isbn BIGINT NOT NULL FOREIGN KEY REFERENCES Buecher(p_ISBN) ON UPDATE CASCADE,
	pf_personen_id INTEGER FOREIGN KEY REFERENCES Nutzer(p_personen_id) ON UPDATE CASCADE,
	PRIMARY KEY (pf_isbn, pf_personen_id)
)

USE[Library]
GO
CREATE TABLE Buecher_Autoren
(
	pf_autor_id INTEGER NOT NULL FOREIGN KEY REFERENCES Autoren(p_autor_id) ON UPDATE CASCADE ON DELETE CASCADE,
	pf_isbn BIGINT NOT NULL FOREIGN KEY REFERENCES Buecher(p_ISBN) ON UPDATE CASCADE,
	PRIMARY KEY (pf_autor_id, pf_isbn)
)


-- https://msdn.microsoft.com/en-us/library/jj851200%28v=vs.103%29.aspx 
