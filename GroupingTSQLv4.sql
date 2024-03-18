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