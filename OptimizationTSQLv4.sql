-- Данные хранятся в страницах, одна страница - один объект: таблица, индекс или индексирвоанное представление. Размер страницы - 8кБ.
-- 8 страниц = экстент. Смешанный экстент - страницы принадлежат разным объектам, однороный экстент - страницы принадлежат одному объекту.
-- Оптимазция заключается в том, что нужно уменьшить количество операций дискового ввода-вывода, то есть уменьшить количество страниц, из которых необходимо читать
-- данные. Мы можем получить информацию о количестве страниц на таблицу, к которым получают доступ запросы.

-- Следующий код проверяет число страниц, которые таблицы Sales.Customers и
-- Sales.Orders занимают в базе данных TSQL2012. 

-- DBCC DROPCLEANBUFFERS;
-- SET STATISTICS IO ON;
-- SELECT * FROM Sales.Customers;
-- SELECT * FROM Sales.Orders;
-- Инструкция DBCC DROPCLEANBUFFERS удаляет данные из кэша.
-- SQL Server кэширует не только данные планов запросов и процедур. Чтобы показать статистику ввода-вывода, лучше не иметь данных в кэше. 
-- Но следует соблюдать исключительную осторожность при очистке кэша на рабочем сервере. SQL
-- Server кэширует данные для ускорения выполнения запросов; поскольку часть данных кэшируется, когда они понадобятся в следующий раз, 
-- SQL Server может извлечь их из памяти, а не с диска, таким образом выполнив запрос, которому эти
-- данные нужны, значительно быстрее



-- Следующая команда SET STATISTICS TIME ON. Вы видите, что возвращенная статистика по времени содержит время ЦП (CPU) и
-- общее (затраченное) время, необходимое для выполнения операции. Кроме того, вы
-- можете видеть действительное время выполнения и время, необходимое для предшествующих выполнению этапов, включая грамматический разбор, связывание,
-- оптимизацию и компиляцию

-- SET STATISTICS TIME ON;
-- DBCC DROPCLEANBUFFERS;
-- SELECT C.custid, C.companyname,
--     O.orderid, O.orderdate
-- FROM Sales.Customers AS C
--     INNER JOIN Sales.Orders AS O
--         ON C.custid = O.custid;




-- План выполнения запроса. ПКМ -> Display Estimated Execution Plan

-- На плане выполнения можно увидеть физические операторы, используемые в процессе выполнения. 
-- План выполнения читается справа налево и сверху вниз. 
-- SQL Server начал выполнение этого запроса с поиска кластеризованного индекса в таблице Sales.Customers и 
-- некластеризованного индекса в таблице Sales.Orders. Затем
-- SQL Server объединил результаты предыдущих операций и объединение с использованием вложенных циклов и т. д. (У меня план отличается - Merge Join вместе вложенных циклов)
-- Также вы можете увидеть относительную стоимость каждого оператора в общей стоимости запроса, 
-- выраженную в процентном отношении к общим затратам на выполнение запроса. В данном примере первые
-- два оператора имеют 99% (46 + 53) от общей стоимости запроса. (Конкретно у меня 25%/27%).
-- Стрелки указывают на поток данных от одного физического оператора к другому.
-- Толщина стрелки соответствует относительному количеству строк, переданных от
-- оператора к оператору. Задержав указатель мыши на операторе или стрелке, вы
-- можете получить значительно больше дополнительной информации.

-- SELECT C.custid, MIN(C.companyname) AS companyname,
-- 	COUNT(*) AS numorders
-- FROM Sales.Customers AS C
-- 	INNER JOIN Sales.Orders AS O
-- 		ON C.custid = O.custid
-- WHERE O.custid < 5
-- GROUP BY C.custid
-- HAVING COUNT(*) > 6;