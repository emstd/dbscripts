--CREATE DATABASE TechCardsDb

-- USE TechCardsDb

-- CREATE TABLE MeasureUnits(
--     Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
--     Name NVARCHAR(100),
-- )

-- CREATE TABLE IngredientCategories(
--     Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
--     Name NVARCHAR(100),
-- )

-- CREATE TABLE Ingredients (
--     Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
--     Name NVARCHAR(100),
--     Price DECIMAL(19, 4),
--     MeasureUnitId INT NOT NULL,
--     IngredientCategoriesId INT NOT NULL
--     CONSTRAINT FK_Ingredients_MeasureUnits FOREIGN KEY (MeasureUnitId) REFERENCES MeasureUnits(Id),
--     CONSTRAINT [FK_Ingredients_IngredientCategories] FOREIGN KEY (IngredientCategoriesId) REFERENCES IngredientCategories(Id)
-- )

-- CREATE TABLE Cakes(
--     Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
--     Name NVARCHAR(100),
--     Description NVARCHAR(500),
-- )

-- CREATE TABLE CakesIngredients(
--     CakeId INT NOT NULL,
--     IngredientId INT NOT NULL,
--     CONSTRAINT [PK_CakeId_IngredientId] PRIMARY KEY (CakeId, IngredientId),
--     CONSTRAINT [FK_CakesIngredients_Cakes] FOREIGN KEY (CakeId) REFERENCES Cakes(Id),
--     CONSTRAINT [FK_CakesIngredients_Ingredients] FOREIGN KEY (IngredientId) REFERENCES Ingredients(Id)
-- )

-- INSERT Ingredients (Name, Price)
-- VALUES ('Sugar', 15)

-- DROP TABLE Ingredients
-- ALTER TABLE Ingredients
-- ALTER COLUMN Id INT NOT NULL

-- ALTER TABLE Ingredients
-- ALTER COLUMN Name NVARCHAR(100)






-- ******************************************



-- DROP DATABASE TechCardsDb

-- CREATE DATABASE ccdb;
USE ccdb;

-- CREATE TABLE Tastes
-- (
--     Id INT IDENTITY(1,1),
--     Name NVARCHAR(100),
--     CONSTRAINT PK_Taste_Id PRIMARY KEY (Id)
-- );

-- CREATE TABLE Categories
-- (
--     Id INT IDENTITY(1,1),
--     Name NVARCHAR(100),
--     CONSTRAINT PK_Category_Id PRIMARY KEY (Id)
-- );

-- CREATE TABLE Cakes
-- (
--     Id INT IDENTITY(1,1),
--     Name NVARCHAR(100),
--     Description NVARCHAR(500),
--     CategoryId INT,
--     TasteId INT,
--     Level INT,
--     Weight DECIMAL(3,2)
-- );


-- ************ Вкусы ************
-- INSERT INTO Tastes 
-- VALUES 
-- (N'Шоколад'),
-- (N'Апельсин'),
-- (N'Киви'),
-- (N'Сливочный'), 
-- (N'Ананас')

-- INSERT INTO Tastes VALUES
-- (N'Медовый');

-- DELETE FROM Tastes
-- WHERE Id IN (1, 2);
-- SELECT * FROM Tastes;
-- DROP TABLE Tastes;

-- ALTER TABLE Tastes
-- ADD CONSTRAINT UQ_Taste_Name UNIQUE (Name);


-- ************ Категории ************
-- INSERT INTO Categories
-- VALUES
-- (N'Чизкейки'),
-- (N'Торты'),
-- (N'Десерты')

-- ALTER TABLE Categories
-- ADD CONSTRAINT UQ_Category_Name UNIQUE (Name);

-- ************ Торты ************
-- INSERT INTO Cakes VALUES
-- (N'Наполеон', N'Слоеный торт', 2, 4, 2, 1),
-- (N'Новинка', N'Шоколадный слоеный торт', 2, 1, 2, 1),
-- (N'Медовик', N'Медовый торт', 2, 7, 2, 1);

-- INSERT INTO Cakes VALUES
-- (N'Тирамису', N'Торт бисквитный', 2, 2, 1, 1.50),
-- (N'Птичье чудо', N'Торт суфле', 2, 5, 1, 2),
-- (N'Три шоколада', N'Торт бискитный', 2, 7, 1, 2.50);

-- INSERT INTO Cakes VALUES
-- (N'Шарлотка', N'Сладкий десерт из яблок', 3, 1, 3, 1),
-- (N'Штрудель', N'Изделие в виде рулета', 3, 5, 2, 3),
-- (N'Брауни', N'Шоколадное пирожное', 3, 1, 2, 2.50),
-- (N'Шоколадный чизкейк', N'Чизкейк с шоколадом', 1, 1, 2, 1),
-- (N'Апельсиновый чизкейк', N'Чизкейк с апельсином', 1, 2, 2, 1),
-- (N'Чизкейк Киви', N'Чизкейк с киви', 1, 3, 2, 2);

-- ALTER TABLE Cakes
-- ADD CONSTRAINT UQ_Cake_Name UNIQUE (Name)

--************ Запросы ************

-- SELECT * FROM Tastes;
-- SELECT * FROM Categories;
-- SELECT * FROM Cakes;

-- SELECT TasteId, SUM(Weight) FROM Cakes
-- GROUP BY TasteId;

-- SELECT TasteId, MIN(Weight) as 'Min weight', MAX(Weight) as 'Max weight' FROM Cakes
-- GROUP BY TasteId;

-- SELECT TasteId, CategoryId,
--     COUNT(*) as 'Total cakes',
--     MIN(Weight) as 'Min weight', 
--     MAX(Weight) as 'Max weight',
--     AVG(Weight) as 'AVG weight',
--     MIN(Level) as 'Min level',
--     MAX(Level) as 'Max level',
--     AVG(Level) as 'AVG level'
-- FROM Cakes
-- GROUP BY TasteId, CategoryId;

-- SELECT CategoryId,
--     COUNT(*) as 'Total cakes',
--     MIN(Weight) as 'Min weight', 
--     MAX(Weight) as 'Max weight',
--     AVG(Weight) as 'AVG weight',
--     MIN(Level) as 'Min level',
--     MAX(Level) as 'Max level',
--     AVG(Level) as 'AVG level'
-- FROM Cakes
-- WHERE Level < 2
-- GROUP BY CategoryId;

-- SELECT * FROM Cakes
-- WHERE Description LIKE N'То%биск%'

-- SELECT Name FROM Cakes
-- WHERE CategoryId = 2 and Weight > 1.5

-- SELECT Name, Description, Weight FROM Cakes
-- WHERE Name IN (N'Три шоколада', N'птичье чудо')

-- SELECT * FROM Cakes
-- ORDER BY Weight DESC

-- SELECT * FROM Cakes
-- WHERE Level BETWEEN 1 and 2 and Weight BETWEEN 2 and 3

-- UPDATE Cakes
-- SET [Description] = N'Чизкейк со вкусом киви'
-- WHERE Name LIKE N'%Киви'

-- INSERT Cakes VALUES
-- (N'Test2', N'Test desc', 2, 2, 1, 3)
-- DELETE Cakes
-- WHERE Name LIKE N'Test%'

-- SELECT * FROM Cakes c
-- INNER JOIN Categories cat ON c.CategoryId = cat.Id

-- SELECT c.Name as 'Название торта', cat.Name as 'Категория' FROM Cakes c
-- INNER JOIN Categories cat ON c.CategoryId = cat.Id

-- SELECT c.Name as 'Название торта', t.Name as 'Вкус' FROM Cakes c
-- INNER JOIN Tastes t ON c.TasteId = t.Id

-- SELECT c.Name as 'Название торта', cat.Name as 'Категория', t.Name as 'Вкус' FROM Cakes c
-- INNER JOIN Tastes t ON c.TasteId = t.Id
-- INNER JOIN Categories cat ON c.CategoryId = cat.Id

-- WITH CakeInfo AS 
--     (
--         SELECT c.Name as 'Название торта', cat.Name as 'Категория', t.Name as 'Вкус' FROM Cakes c
--         INNER JOIN Tastes t ON c.TasteId = t.Id
--         INNER JOIN Categories cat ON c.CategoryId = cat.Id
--     )
-- SELECT * FROM CakeInfo
-- WHERE Вкус = N'Медовый'


-- SELECT cat.Name as 'Категория', t.Name as 'Вкус' FROM Cakes c
-- INNER JOIN Tastes t ON c.TasteId = t.Id
-- INNER JOIN Categories cat ON c.CategoryId = cat.Id
-- GROUP BY cat.Name, t.Name

-- SELECT cat.Id, cat.Name, COUNT(*) as 'Total', AVG(c.Weight) as 'Средний вес', AVG(c.Level) as 'Средняя сложность' FROM Cakes c
-- INNER JOIN Tastes t ON c.TasteId = t.Id
-- INNER JOIN Categories cat ON c.CategoryId = cat.Id
-- GROUP BY cat.Name, cat.Id
-- ORDER BY cat.Id