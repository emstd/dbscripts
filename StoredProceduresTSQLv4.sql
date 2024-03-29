-- Простой запрос:

-- SELECT orderid, custid, shipperid, orderdate, requireddate, shippeddate
-- FROM Sales.Orders
-- WHERE custid = 37
-- AND orderdate >= '2015-04-01'
-- AND orderdate < '2015-07-01';

-- Чтобы сделать код более общим, можно вместо литеральных значений использовать переменные:

-- DECLARE @custid AS INT,
--         @orderdatefrom AS DATETIME,
--         @orderdateto AS DATETIME;
-- SET @custid = 37;
-- SET @orderdatefrom = '2015-04-01';
-- SET @orderdateto = '2015-07-01';
-- SELECT orderid, custid, shipperid, orderdate, requireddate, shippeddate
-- FROM Sales.Orders
-- WHERE custid = @custid
-- AND orderdate >= @orderdatefrom
-- AND orderdate < @orderdateto;


-- Если его инкапсулировать в хранимую процедуру:

-- IF OBJECT_ID('Sales.GetCustomerOrders', 'P') IS NOT NULL    -- Если процедура существует, то CREATE возовет ошибку, потом проверяем,
--     DROP PROC Sales.GetCustomerOrders;                      -- если существует - удаляем
-- GO
-- CREATE PROCEDURE Sales.GetCustomerOrders
--     @custid AS INT,                             -- custid - обязательный параметр, @orderdatefrom и @orderdateto нет, так как имеют значение по-дефолту
--     @orderdatefrom AS DATETIME = '19000101',
--     @orderdateto AS DATETIME = '99991231',
--     @numrows AS INT = 0 OUTPUT                  -- Ключевое слово OUTPUT определяет специальный параметр, который возвращает значения вызывающей стороне. Выходные параметры всегда являются необязательными параметрами.
-- AS                                              -- Команда AS обязательно должна стоять после списка параметров.
--     BEGIN                                       -- Слова BEGIN..END необязательны, просто делает код более понятным
--         SET NOCOUNT ON;                         -- Можно встроить инструкцию NOCOUNT со значением ON внутрь хранимой процедуры, чтобы запретить вывод сообщений, подобный (3 row(s) affected), при каждом выполнении процедуры.
--                                                 -- И так как сообщение (3 row(s) affected) не возвращается клиенту - при частом вызове это повышает производительность (уменьшение сетевых взаимодействий)
--         SELECT orderid, custid, shipperid, orderdate, requireddate, shippeddate
--         FROM Sales.Orders
--         WHERE custid = @custid
--             AND orderdate >= @orderdatefrom
--             AND orderdate < @orderdateto;
--         SET @numrows = @@ROWCOUNT; 
--         RETURN;                                 -- Хранимая процедура заканчивается тогда, когда заканчивается пакет, но с помощью команды RETURN можно заставить процедуру завершиться в любой точке.
--                                                 -- В одной процедуре можно использовать более одной команды RETURN. Инструкции, стоящие после команды RETURN, не выполняются.
--                                                 -- При успешном выполнеии возвращается статус 0, при ошибках - отрицательное число. Можно отправить собственные коды возврата назад вызывающей стороне, вставив целочисленные значения после инструкции RETURN.
--     END
-- GO


-- Вызов этой процедуры. В результате мы получаем тот же самый набор строк с данными, но кроме этого,
-- мы также получаем число строк в специальном параметре OUTPUT:
-- DECLARE @rowsreturned AS INT;
-- EXECUTE Sales.GetCustomerOrders
--     @custid = 37,
--     @orderdatefrom = '20150401',
--     @orderdateto = '20150701',
--     @numrows = @rowsreturned OUTPUT;     -- Ключевое слово OUTPUT обязательно, если хотим получить возвращаемое значение из процедуры, если не указать - вернется NULL. Сам по себе выходной параметр не обязателен
-- SELECT @rowsreturned AS "Rows Returned";
-- GO

-- Аналогичный вывод с передачей параметра по позиции, EXEC то же самое, что EXECUTE. Можем проигнорировать необязательный параметр OUTPUT.
-- Порядок обязательно должен совападать:
-- EXEC Sales.GetCustomerOrders 37, '20150401', '20150701';

-- Аналогичный вывод с именованными параметрами (Порядок  может быть любым в таком случае):
-- EXEC Sales.GetCustomerOrders @orderdatefrom = '20150401', @custid = 37, @orderdateto = '20150701';

-- Так как обязательный параметр только custid, то можно вызывать так:
-- EXEC Sales.GetCustomerOrders @custid = 37; 
-- EXEC Sales.GetCustomerOrders 37;




-- Условные операторы


-- IF ELSE
-- DECLARE @var1 AS INT, @var2 AS INT;
-- SET @var1 = 1;
-- SET @var2 = 2;
-- IF @var1 = @var2
--     PRINT 'The variables are equal';
-- ELSE
--     PRINT '@var1 not equals @var2';
-- GO

-- Если инструкции IF или ELSE используются без блока BEGIN/END, каждая из них обрабатывает только одну инструкцию.
-- Если не указать BEGIN/END, то вторая инструкция из неподходящего блока будет выполнена.

-- DECLARE @var1 AS INT, @var2 AS INT;
-- SET @var1 = 1;
-- SET @var2 = 1;
-- IF @var1 = @var2
--     BEGIN
--         PRINT 'The variables are equal';
--         PRINT '@var1 equals @var2';
--     END
-- ELSE
--     BEGIN
--         PRINT 'The variables are not equal';
--         PRINT '@var1 does not equal @var2';
--     END
-- GO



-- Цикл WHILE

-- SET NOCOUNT ON;
-- DECLARE @count AS INT = 1;
-- WHILE @count <= 10
--     BEGIN
--         PRINT CAST(@count AS NVARCHAR);
--         SET @count += 1;
--     END;

-- WHILE с операторами BREAK и CONTINUE:

-- GO
-- SET NOCOUNT ON;
-- DECLARE @count AS INT = 1;
-- WHILE @count <= 100
--     BEGIN
--         IF @count = 10
--             BREAK;               -- прервать цикл совсем
--         IF @count = 5
--             BEGIN
--                 SET @count += 2;
--                 CONTINUE;        -- прервать текущую итерацию и перейти к следующей
--             END
--         PRINT CAST(@count AS NVARCHAR);
--         SET @count += 1;
--     END;

-- Пример WHILE для INT столбцов:
-- DECLARE @categoryid AS INT;
-- SET @categoryid = (SELECT MIN(categoryid) FROM Production.Categories); -- берем минимальный categoryid
-- WHILE @categoryid IS NOT NULL                                          -- пока не NULL
--     BEGIN
--         PRINT CAST(@categoryid AS NVARCHAR);
--         SET @categoryid = (SELECT MIN(categoryid) FROM Production.Categories    -- выбираем минимальный categoryid,
--             WHERE categoryid > @categoryid);                                    -- но который больше предыдущего
--     END;
-- GO

-- Еще пример WHILE, только для столбцов с текстовым типом (этот код не покажет дубликаты, повторные значения будут пропущены):
-- DECLARE @categoryname AS NVARCHAR(15);
-- SET @categoryname = (SELECT MIN(categoryname) FROM Production.Categories);
-- WHILE @categoryname IS NOT NULL
--     BEGIN
--         PRINT @categoryname;
--         SET @categoryname = (SELECT MIN(categoryname) FROM Production.Categories
--         WHERE categoryname > @categoryname);
--     END;
-- GO



-- WAITFOR. может вызывать паузу в выполнении инструкции на определенный период времени.

-- WAITFOR DELAY '00:00:20';    -- Останавливает выполнение кода на 20 секунд
-- WAITFOR TIME '23:46:00';     -- Приостанавливает выполнение кода до указанного времени (Тут до 23 часов 46 минут 00 секунд)



-- GOTO. Позволяет перепрыгнуть на определенную метку. Тут вторая инструкция PRINT пропускается

-- PRINT 'First PRINT statement';
-- GOTO MyLabel;
-- PRINT 'Second PRINT statement';
-- MyLabel:
-- PRINT 'End';



-- Процедуры могут посылать обратно более одного результирующего набора
-- IF OBJECT_ID('Sales.ListSampleResultsSets', 'P') IS NOT NULL
--  DROP PROC Sales.ListSampleResultsSets;
-- GO
-- CREATE PROC Sales.ListSampleResultsSets
-- AS
-- BEGIN
--     SELECT TOP (1) productid, productname, supplierid,
--         categoryid, unitprice, discontinued
--     FROM Production.Products;
--     SELECT TOP (1) orderid, productid, unitprice, qty, discount
--     FROM Sales.OrderDetails;
-- END
-- GO                                                   -- Создали процедуру, возвращающую 2 набора по одной строке (результат функции TOP())

-- EXEC Sales.ListSampleResultsSets                     -- Вызываем эту процедуру







-- В этом задании вам нужно разработать хранимую процедуру для создания резервной копии базы данных. Сначала вы создадите сценарий и цикл WHILE, 
-- а затем постепенно будете усовершенствовать код, чтобы в конечном итоге создать хранимую процедуру с параметром, указывающим тип базы данных, для которой нужно
-- создать резервную копию

-- IF OBJECT_ID('dbo.BackupDatabases', 'P') IS NOT NULL
--     DROP PROCEDURE dbo.BackupDatabases;
-- GO

-- CREATE PROCEDURE dbo.BackupDatabases
--     @databasetype AS NVARCHAR(30)       -- Входной парметр процедуры (какого типа БД будет бэкапить - системные(4 штуки) или пользовательские)
-- AS
-- BEGIN
--     DECLARE @databasename AS NVARCHAR(128),     -- название базы данных
--             @timecomponent AS NVARCHAR(50),     -- время созданя бэкапа (укажется в названии бэкапа)
--             @sqlcommand AS NVARCHAR(1000);      -- сама команда, которая будет создавать бэкап БД

--     IF @databasetype NOT IN ('User', 'System')  -- если передали тип БД не системный и не пользовательский, то генеируем исключение
--     BEGIN
--         THROW 50000, 'dbo.BackupDatabases: @databasetype must be User or System', 0;
--         RETURN;
--     END;

--     IF @databasetype = 'System'     -- Тут берем "минимальное" название БД либо для типа System, либо для типа User's
--         SET @databasename = (SELECT MIN(name) FROM sys.databases WHERE name IN ('master', 'model', 'msdb', 'tempdb'));
--     ELSE
--         SET @databasename = (SELECT MIN(name) FROM sys.databases WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb'));

--     WHILE @databasename IS NOT NULL     -- Пробегаем по всем БД заданного типа (системные или пользовательские)
--     BEGIN
--         SET @timecomponent = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, GETDATE(), 120), ' ', '_'), ':', ''), '-', '');      -- Например, из (2024-03-28 22:42:51) получится (20240328_224143) это будет в названии бэкапа
--         SET @sqlcommand = 'BACKUP DATABASE ' + @databasename + ' TO DISK = ''C:\Backups\' + @databasename + '_' + @timecomponent + '.bak''';    -- Сама SQL команда для создания бэкапа
--         PRINT @sqlcommand;  -- Выведем ее в сообщения
--         -- EXEC(@sqlcommand);   -- раскомментировать, если хочется выполнить команду бэкапа, иначе она просто выводится в сообщения
--         IF @databasetype = 'System'     -- Если были указаны во вх. параметре системные, то берем следующую по списку после "минимальной", так же для пользовательских БД 
--             SET @databasename = (SELECT MIN(name) FROM sys.databases WHERE name IN ('master', 'model', 'msdb', 'tempdb') AND name > @databasename);
--         ELSE
--             SET @databasename = (SELECT MIN(name) FROM sys.databases WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') AND name > @databasename);
--     END;
-- END;
-- GO

-- Протестируем процедуру, созданную выше.
-- EXEC dbo.BackupDatabases;   -- тут будет ошибка, так как не передан входной параметр
-- GO
-- EXEC dbo.BackupDatabases 'User';    -- выполнит бэкап пользовательских БД
-- GO
-- EXEC dbo.BackupDatabases 'System';  -- выполнит бэкап системных БД
-- GO
-- EXEC dbo.BackupDatabases 'Unknown'  -- будет ошибка, так как ожидается входной параметр 'User' или 'System'


