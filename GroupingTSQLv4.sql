--группировка и оконные функции

-- USE TSQLV4;
-- SELECT COUNT(*) AS numorders
-- FROM Sales.Orders;

-- SELECT shipperid, YEAR(shippeddate) as shippedyear,
--         COUNT(1) as numorders
-- FROM Sales.Orders
-- WHERE shippeddate IS NOT NULL
-- GROUP BY shipperid, YEAR(shippeddate)
-- HAVING COUNT(1) < 100

-- SELECT shipperid,
--         COUNT(*) AS numorders,
--         COUNT(shippeddate) AS shippedorders,
--         MIN(shippeddate) AS firstshipdate,
--         MAX(shippeddate) AS lastshipdate,
--         SUM(val) AS totalvalue
-- FROM Sales.OrderValues
-- GROUP BY shipperid;

-- SELECT shipperid, COUNT(DISTINCT shippeddate) AS numshippingdates
-- FROM Sales.Orders
-- GROUP BY shipperid;

--SELECT shipperid, YEAR(shippeddate) AS shipyear, COUNT(*) AS numorders
--FROM Sales.Orders
--WHERE shippeddate IS NOT NULL
--GROUP BY GROUPING SETS
--(
--    ( shipperid, YEAR(shippeddate)),
--    ( shipperid ),
--    ( YEAR(shippeddate) ),
--    ( )
--);



-- Статистические оконные функции

--SUM(val) здесь применяется к окну одинаковых custid, в каждом окне данные сортируются по дате. Значение runningtotal является суммой всех предыдущих значений
-- val в окне по отношению к текущей строке.

-- SELECT custid, orderid, orderdate, val,
--     SUM(val) OVER
--     (
--         PARTITION BY custid
--         ORDER BY orderdate, orderid
--         ROWS BETWEEN UNBOUNDED PRECEDING    --строки с начала секции(окна)
--             AND CURRENT ROW                 --по текущую строку
--     ) AS runningtotal
-- FROM Sales.OrderValues;

-- Если нужно сослаться на результат оконной функции до SELECT, то нужно использоваться табличное выражение:
-- WITH RunningTotals AS
-- ( 
--     SELECT custid, orderid, orderdate, val,
--     SUM(val) OVER
--         (
--             PARTITION BY custid
--             ORDER BY orderdate, orderid
--             ROWS BETWEEN UNBOUNDED PRECEDING
--                 AND CURRENT ROW
--         ) AS runningtotal
--     FROM Sales.OrderValues 
-- )
-- SELECT *
-- FROM RunningTotals
-- WHERE runningtotal < 1000.00;

-- А если нужно взять только первые 3 строки, то нужно использовать - ROWS BETWEEN 2 PRECEDING AND CURRENT ROW, то есть взять текущую строку и первые 2




-- Ранжирующие оконные функции

-- SELECT custid, orderid, val,
--     ROW_NUMBER() OVER(ORDER BY val) AS rownum,      -- порядковый номер строки в окне, начиная с 1, поскольку нет секционирования окна (Partition), то все 830 строк нумеруются с 1 до 830
--     RANK() OVER(ORDER BY val) AS rnk,               -- возвращает ранг строки. Если значения, указанные в order by одинаковые, то ранг одинаковый, а следующий будет со смещением, например распределение мест 3 человек:  1 место, 1 место, 3 место
--     DENSE_RANK() OVER(ORDER BY val) AS densernk,    -- возвращает ранг строки. Если значения, указанные в order by одинаковые, то ранг одинаковый, только следующий ранг будет без смещения, то есть при распределении мест: 1 место, 1 место, 2 место
--     NTILE(100) OVER(ORDER BY val) AS ntile100       -- позволяет организовать строки внутри секции в запрашиваемое количество групп одинакового размера на основе указанной сортировки
-- FROM Sales.OrderValues;

-- Подробнее про NTILE: 
-- В нашем учебном запросе
-- мы запрашивали 100 групп. В результирующем наборе — 830 строк, и, следовательно, базовый размер группы составляет 830/100 = 8 с остатком 30. Поскольку
-- есть остаток, равный 30, первые 30 групп содержат по дополнительной строке.
-- А именно, группы 1—30 будут иметь по 9 строк, и все оставшиеся группы (от 31
-- до 100) — по 8 строк. Посмотрите, в результате этого запроса первым 9 строкам
-- (в соответствии с сортировкой по столбцу val) присвоен номер группы 1, затем
-- следующим 9 строкам присвоен номер группы 2 и т. д



-- Оконные функции смещения:
-- SELECT custid, orderid, orderdate, val,
--     LAG(val) OVER(PARTITION BY custid               -- группируем окна по custid, сортируем по дате и orderid, функция LAG возвращает для каждой текущей строки значение val в ПРЕДЫДУЩЕЙ строке
--         ORDER BY orderdate, orderid) AS prev_val,
--     LEAD(val) OVER(PARTITION BY custid              -- группируем окна по custid, сортируем по дате и orderid, функция LAG возвращает для каждой текущей строки значение val в СЛУДЕЮЩЕЙ строке
--         ORDER BY orderdate, orderid) AS next_val
-- FROM Sales.OrderValues;
-- Поскольку явное смещение не указано, обе функции используют в качестве него
-- значение по умолчанию, равное 1. При желании иметь смещение, отличное от 1,
-- следует указать его вторым аргументом, как в случае LAG(val, 3).
-- Заметьте, что если строка не существует на запрашиваемом смещении, функция
-- возвращает по умолчанию значение NULL. Если в этом случае нужно возвращать
-- другое значение, его следует указать в качестве третьего элемента, как в случае
-- LAG(val, 3, 0).

-- SELECT custid, orderid, orderdate, val,         -- Функции FIRST_VALUE и LAST_VALUE возвращают выражение значения из первой или
-- FIRST_VALUE(val) OVER                           -- последней строки в оконном кадре соответственно
--     (
--         PARTITION BY custid
--         ORDER BY orderdate, orderid
--         ROWS BETWEEN UNBOUNDED PRECEDING
--             AND CURRENT ROW
--     ) AS first_val,
--     LAST_VALUE(val) OVER
--     (
--         PARTITION BY custid
--         ORDER BY orderdate, orderid
--         ROWS BETWEEN CURRENT ROW
--             AND UNBOUNDED FOLLOWING
--     ) AS last_val
-- FROM Sales.OrderValues; 