-- SQL Server поддерживает триггеры с двумя типами событий:
-- 1) события обработки данных (триггеры DML):
--          - AFTER — этот триггер срабатывает после того, как событие, с которым он связан,
--          завершается, и может быть определен только для постоянных таблиц;
--          - INSTEAD OF — этот триггер срабатывает вместо события, с которым он связан,
--          и может быть определен в постоянных таблицах и представлениях

-- 2) события описания данных (триггеры DDL), такие как CREATE TABLE.



-- Когда выполняются инструкции INSERT, UPDATE или DELETE и не обрабатываются никакие
-- строки, нет смысла в продолжении работы триггера. Можно повысить производительность
-- триггера, выполняя проверку @@ROWCOUNT на равенство 0 в самой первой строке триггера.
-- Это должна быть первая строка, поскольку @@ROWCOUNT будет переустановлена в 0 любой
-- дополнительной инструкцией. Когда триггер AFTER начнет работать, @@ROWCOUNT будет со-
-- держать число строк, задействованных внешней инструкцией INSERT, UPDATE или DELETE.


-- IF OBJECT_ID('Sales.tr_SalesOrderDetailsDML', 'TR') IS NOT NULL     -- Если уже есть такой триггер - удалить его
--     DROP TRIGGER Sales.tr_SalesOrderDetailsDML;
-- GO
-- CREATE TRIGGER Sales.tr_SalesOrderDetailsDML
--     ON Sales.OrderDetails
--         AFTER DELETE, INSERT, UPDATE
-- AS
-- BEGIN
--     IF @@ROWCOUNT = 0 RETURN; -- Должна быть первой инструкцией
--     SET NOCOUNT ON;
--     SELECT COUNT(*) AS InsertedCount FROM Inserted; -- таблица Inserted содержит новый образ подвергнувшихся воздействию строк в случае инструкций INSERT и UPDATE
--     SELECT COUNT(*) AS DeletedCount FROM Deleted;   -- таблица Deleted содержит старый образ обработанных строк в случае инструкций DELETE и UPDATE
-- END;



-- Таблица Production.Categories не имеет ограничения уникальности или уникального индекса на столбце categoryname.
-- Следующий код добавляет уникальность с помощью триггера AFTER.

-- IF OBJECT_ID('Production.tr_ProductionCategories_categoryname', 'TR')
--     IS NOT NULL
--     DROP TRIGGER Production.tr_ProductionCategories_categoryname;
-- GO
-- CREATE TRIGGER Production.tr_ProductionCategories_categoryname
-- ON Production.Categories
-- AFTER INSERT, UPDATE
-- AS
-- BEGIN
--     IF @@ROWCOUNT = 0 RETURN;
--     SET NOCOUNT ON;
--     IF EXISTS (SELECT COUNT(*)
--         FROM Inserted AS I
--             JOIN Production.Categories AS C
--                 ON I.categoryname = C.categoryname
--         GROUP BY I.categoryname
--         HAVING COUNT(*) > 1 )
--     BEGIN
--         THROW 50000, 'Duplicate category names not allowed', 0;
--     END;
-- END;
-- GO

-- Протестируем:
-- INSERT INTO Production.Categories (categoryname, description)
-- VALUES ('TestCategory1', 'Test1 description v1');       -- Выполнится один раз, при втором выполнении выдаст ошибку Duplicate category names not allowed

-- UPDATE Production.Categories SET categoryname = 'Beverages' -- Сразу выдаст ошибку Duplicate category names not allowed, так как такая категория уже есть
-- WHERE categoryname = 'TestCategory1';

-- DELETE FROM Production.Categories WHERE categoryname = 'TestCategory1'; -- очистка прошлого эксперемента

-- Триггеры AFTER могут быть вложенными, т. е. можно иметь триггер для таблицы A,
-- который обновляет таблицу B. Таблица B, в свою очередь, также может иметь триг-
-- гер, который выполняется. Максимальная глубина выполнения вложенных тригге-
-- ров равна 32. Если же вложенность является циклической (триггер таблицы A за-
-- пускает триггер таблицы B, который запускает триггер таблицы C, который запус-
-- кает триггер таблицы A и т. д.), максимальный уровень вложенности, равный 32,
-- будет достигнут, и выполнение триггера прекратится.






-- Триггер INSTEAD OF выполняет пакет кода T-SQL вместо инструкций INSERT, UPDATE или DELETE.
-- Хотя триггеры INSTEAD OF могут создаваться как для таблиц, так и для представле-
-- ний, обычно они используются с представлениями. Причина в том, что когда инст-
-- рукция UPDATE отправляется к представлению, может быть обновлена только одна
-- таблица за один раз. Кроме того, в представлении могут быть агрегаты функций на
-- столбцах, не допускающие прямого обновления. Триггер INSTEAD OF может взять
-- инструкцию UPDATE применительно к представлению и, вместо ее выполнения, за-
-- менить ее двумя инструкциями UPDATE применительно к базовой таблице представ-
-- ления.

-- Например, возьмем триггер AFTER из предыдущего раздела и перепишем его как триггер INSTEAD OF
-- IF OBJECT_ID('Production.tr_ProductionCategories_categoryname', 'TR')
--         IS NOT NULL
--     DROP TRIGGER Production.tr_ProductionCategories_categoryname;
-- GO
-- CREATE TRIGGER Production.tr_ProductionCategories_categoryname
-- ON Production.Categories
-- INSTEAD OF INSERT
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     IF EXISTS (SELECT COUNT(*)
--         FROM Inserted AS I
--             LEFT JOIN Production.Categories AS C
--                 ON I.categoryname = C.categoryname
--         GROUP BY I.categoryname
--         HAVING COUNT(*) > 0 )
--     BEGIN
--         THROW 50000, 'Duplicate category names not allowed', 0;
--     END;
--     ELSE
--         INSERT Production.Categories (categoryname, description)
--         SELECT categoryname, description FROM Inserted;
-- END;
-- GO
-- -- Очистка
-- IF OBJECT_ID('Production.tr_ProductionCategories_categoryname', 'TR')
-- IS NOT NULL
-- DROP TRIGGER Production.tr_ProductionCategories_categoryname;