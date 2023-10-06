Use Cruise

-- Designing Data Mart

-- Dimension Ship
CREATE TABLE Cruise.DimShip(
    Ship_ID int IDENTITY(1,1) NOT NULL,
    Ship_Name varchar(20) NULL
    CONSTRAINT PK_Ship_ID PRIMARY KEY (Ship_ID)
)

-- Dimension Tour
CREATE TABLE Cruise.DimTour(
    Tour_ID int IDENTITY(1,1) NOT NULL,
    Tour_Name varchar(20) NULL,
    Tour_Desc varchar(200) NULL
    CONSTRAINT PK_Tour_ID PRIMARY KEY (Tour_ID)
)

-- Fact Table
CREATE TABLE Cruise.FactCruise(
    Cruise_Number int NOT NULL,
    Ship_ID int,
    Tour_ID int,
    Launch_Datetime datetime NULL,
    Start_Datetime datetime NULL,
    End_Datetime datetime NULL,
    Tour_Datetime datetime NULL,
    Duration decimal(4,2) NULL,
    Price int NULL
    CONSTRAINT PK_Cruise_Number PRIMARY KEY (Cruise_Number),
    CONSTRAINT FK_Ship_ID FOREIGN KEY (Ship_ID) REFERENCES Cruise.DimShip(Ship_ID),
    CONSTRAINT FK_Tour_ID FOREIGN KEY (Tour_ID) REFERENCES Cruise.DimTour(Tour_ID)
)

-- Creating the Staging Table
CREATE TABLE Cruise.Staging(
    Staging_ID int IDENTITY(1,1) NOT NULL,
    Cruise_Number int NULL,
    Ship_ID int NULL,
    Tour_ID int NULL,
    Start_Datetime datetime NULL,
    End_Datetime datetime NULL,
    Ship_Name varchar(20) NULL,
    Launch_Datetime datetime NULL,
    Tour_Datetime datetime NULL,
    Tour_Name varchar(20) NULL,
    Tour_Desc varchar(200) NULL,
    Duration decimal(4,2) NULL,
    Price int NULL
    CONSTRAINT PK_Staging_ID PRIMARY KEY (Staging_ID)
)

-- Inserting sample data into out staging table
INSERT INTO Cruise.Staging (Cruise_Number, Start_Datetime, End_Datetime, Ship_Name, Launch_Datetime, Tour_Datetime, Tour_Name, Tour_Desc, Duration, Price)
VALUES 
    (1, '08:00.0', '00:00.0', 'Jubilee', '00:00.0', '00:00.0', 'The Caves', 'Ancient Caves', 0.8, 100.5),
    (2, '08:00.0', '00:00.0', 'Firenze', '00:00.0', '00:00.0', 'The Hills', 'Ancient Hills', 0.9, 110.5),
    (3, '08:00.0', '00:00.0', 'Venezia', '00:00.0', '00:00.0', 'The Fort', 'Ancient Fort', 0.7, 120.5),
    (4, '08:00.0', '00:00.0', 'Celebration', '00:00.0', '00:00.0', 'The Temple', 'Ancient Temples', 0.6, 130.5),
    (5, '08:00.0', '00:00.0', 'Luminosa', '00:00.0', '00:00.0', 'The Monument', 'Ancient Monuments', 0.5, 140.5);

--Inserting data into Data Mart from Staging Table

INSERT INTO Cruise.DimShip([Ship_Name])
    SELECT
    DISTINCT [Ship_Name]
	FROM [Cruise].[Staging]
	ORDER BY [Ship_Name] ASC

INSERT INTO Cruise.DimTour([Tour_Name],[Tour_Desc])
    SELECT
    DISTINCT [Tour_Name],[Tour_Desc]
    FROM [Cruise].[Staging]
	ORDER BY [Tour_Name] ASC

UPDATE Cruise.Staging
SET Cruise.Staging.[Ship_ID] = Cruise.DimShip.[Ship_ID]
FROM Cruise.Staging
INNER JOIN Cruise.DimShip ON
Cruise.Staging.[Ship_Name] = Cruise.DimShip.[Ship_Name];

UPDATE Cruise.Staging
SET Cruise.Staging.[Tour_ID] = Cruise.DimTour.[Tour_ID]
FROM Cruise.Staging
INNER JOIN Cruise.DimTour ON
Cruise.Staging.[Tour_Name] = Cruise.DimTour.[Tour_Name];

INSERT INTO Cruise.FactCruise(Cruise_Number, Ship_ID, Tour_ID, Start_Datetime, End_Datetime, Launch_Datetime, Tour_Datetime, Duration, Price)
    SELECT Cruise_Number, Ship_ID, Tour_ID, Start_Datetime, End_Datetime, Launch_Datetime, Tour_Datetime, Duration, Price
    FROM Cruise.Staging

-- Viewing all the tables
SELECT * FROM Cruise.Staging
SELECT * FROM Cruise.DimTour
SELECT * FROM Cruise.DimShip
SELECT * FROM Cruise.FactCruise