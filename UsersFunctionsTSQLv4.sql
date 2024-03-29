-- Определяемые пользователем функции имеют доступ к данным SQL Server, но не
-- могут выполнять DDL, т. е. они не могут создавать таблицы, а также модифициро-
-- вать таблицы, индексы или любые другие объекты или изменять любые данные
-- в постоянных таблицах с помощью инструкций DML.
-- Существуют два основных типа определяемых пользователем функций: скалярные функции и функции с табличным значением. 
-- Скалярная функция возвращает вызывающей стороне одно значение, тогда как функция с табличным значением возвращает таблицу.

-- При ссылке на тип функции либо из столбца типа представления sys.objects, либо из параметра типа функции OBJECT_ID() используются три
-- сокращенных наименования этих функций:
-- FN = скалярная функция SQL;
-- IF = встроенная функция с табличным значением SQL;
-- TF = функция с табличным значением SQL

-- Код внутри пользовательской скалярной функции должен быть заключен в блок BEGIN/END.

-- CREATE FUNCTION dbo.FunctionName
-- (@param1 int, @param2 int)
-- RETURNS INT
-- AS
-- BEGIN
--     RETURN @param1 + @param2
-- END


-- Создайте простую скалярную функцию для вычисления стоимости как цены, умноженной на количество, в таблице Sales.

-- IF OBJECT_ID('Sales.fn_extension', 'FN') IS NOT NULL
--     DROP FUNCTION Sales.fn_extension
-- GO
-- CREATE FUNCTION Sales.fn_extension
--     ( @unitprice AS MONEY,
--         @qty AS INT )
-- RETURNS MONEY
-- AS
-- BEGIN
--     RETURN @unitprice * @qty
-- END;
-- GO

-- Вызов этой функции:
-- SELECT Orderid, unitprice, qty, Sales.fn_extension(unitprice, qty) AS extension
-- FROM Sales.OrderDetails;

-- Еще пример вызова:
-- SELECT Orderid, unitprice, qty, Sales.fn_extension(unitprice, qty) AS extension
-- FROM Sales.OrderDetails
-- WHERE Sales.fn_extension(unitprice, qty) > 1000;





-- Пользовательская функция с табличным значением возвращает вызывающей сто-
-- роне не единственное значение, а таблицу. Поэтому она может быть вызвана в за-
-- просе T-SQL там, где ожидается табличный результат, как в предложении FROM.
-- Встроенная функция с табличным значением — это единственный тип определяе-
-- мой пользователем функции, которая может быть написана без блока BEGIN/END.

-- IF OBJECT_ID('Sales.fn_FilteredExtension', 'IF') IS NOT NULL
-- DROP FUNCTION Sales.fn_FilteredExtension;
-- GO
-- CREATE FUNCTION Sales.fn_FilteredExtension
-- (
--     @lowqty AS SMALLINT,
--     @highqty AS SMALLINT
-- )
-- RETURNS TABLE AS RETURN
-- ( 
--     SELECT orderid, unitprice, qty
--     FROM Sales.OrderDetails
--     WHERE qty BETWEEN @lowqty AND @highqty 
-- );
-- GO

-- Вызов функции с табличным значением:
-- SELECT orderid, unitprice, qty
-- FROM Sales.fn_FilteredExtension (10,20);




-- Многооператорная пользовательская функция с табличным значением:
-- IF OBJECT_ID('Sales.fn_FilteredExtension2', 'TF') IS NOT NULL
--     DROP FUNCTION Sales.fn_FilteredExtension2;
-- GO
-- CREATE FUNCTION Sales.fn_FilteredExtension2
-- (
--     @lowqty AS SMALLINT,
--     @highqty AS SMALLINT
-- )
-- RETURNS @returntable TABLE
-- (
--     orderid INT,
--     unitprice MONEY,
--     qty SMALLINT
-- )
-- AS
-- BEGIN
--     INSERT @returntable              -- Эта строка выполняет операцию вставки данных в таблицу @returntable. Она выбирает данные из таблицы Sales.OrderDetails, 
--     SELECT orderid, unitprice, qty   -- Где значение столбца qty находится в заданном диапазоне (BETWEEN @lowqty AND @highqty), и вставляет их в таблицу, которая будет возвращена из функции.
--     FROM Sales.OrderDetails
--     WHERE qty BETWEEN @lowqty AND @highqty
--     RETURN                           -- Завершение тела функции и возврат результата выполнения
-- END;
-- GO

-- Вызов этой функции:
-- SELECT orderid, unitprice, qty
-- FROM Sales.fn_FilteredExtension2 (10, 20);