--CREATE DATABASE TechCardsDb

USE TechCardsDb

CREATE TABLE MeasureUnits(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
)

CREATE TABLE IngredientCategories(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
)

CREATE TABLE Ingredients (
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Price DECIMAL(19, 4),
    MeasureUnitId INT NOT NULL,
    IngredientCategoriesId INT NOT NULL
    CONSTRAINT FK_Ingredients_MeasureUnits FOREIGN KEY (MeasureUnitId) REFERENCES MeasureUnits(Id),
    CONSTRAINT [FK_Ingredients_IngredientCategories] FOREIGN KEY (IngredientCategoriesId) REFERENCES IngredientCategories(Id)
)

CREATE TABLE Cakes(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Description NVARCHAR(500),
)

CREATE TABLE CakesIngredients(
    CakeId INT NOT NULL,
    IngredientId INT NOT NULL,
    CONSTRAINT [PK_CakeId_IngredientId] PRIMARY KEY (CakeId, IngredientId),
    CONSTRAINT [FK_CakesIngredients_Cakes] FOREIGN KEY (CakeId) REFERENCES Cakes(Id),
    CONSTRAINT [FK_CakesIngredients_Ingredients] FOREIGN KEY (IngredientId) REFERENCES Ingredients(Id)
)

INSERT Ingredients (Name, Price)
VALUES ('Sugar', 15)

-- DROP TABLE Ingredients
-- ALTER TABLE Ingredients
-- ALTER COLUMN Id INT NOT NULL

-- ALTER TABLE Ingredients
-- ALTER COLUMN Name NVARCHAR(100)