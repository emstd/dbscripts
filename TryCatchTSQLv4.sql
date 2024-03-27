-- В дополнение к сообщениям об ошибках, которые генерирует SQL Server при возникновении ошибки, вы можете инициировать собственные ошибки с помощью
-- двух команд:
-- - более старой команды RAISERROR;
-- - команды SQL Server 2012 THROW.
-- Любая из этих команд может использоваться, чтобы генерировать ваши собственные ошибки в коде T-SQL.

-- Сообщения об ошибке в SQL Server состоит из четырех частей:

-- Номер ошибки (error number) — это целочисленное значение.
--      Сообщения об ошибках SQL Server нумеруются от 1 до 49 999.
--      Пользовательские сообщения об ошибках нумеруются с 50 001 и выше.
--      Ошибка с номером 50 000 зарезервирована для пользовательского сообщения, которое не имеет номера пользовательской ошибки.

-- Уровень серьезности (Severity level). В SQL Server определено 26 уровней серьезности с номерами от 0 до 25.
--     По общему правилу, ошибки с уровнем серьезности от 16 и выше автомати-
-- чески записываются в журнал SQL Server и в журнал приложений Windows.
--     Ошибки с уровнем серьезности от 19 до 25 могут быть указаны только чле-
-- нами предопределенной роли сервера sysadmin.
--     Ошибки с уровнем серьезности от 20 до 25 считаются фатальными (неустранимыми) 
-- и приводят к разрыву соединений и откату всех открытых транзакций.
--     Ошибки с уровнем серьезности 0 до 10 являются информационными.

-- Состояние (state) — целое число с максимальным значением 127, используемое компанией Microsoft для внутренних целей.

-- Сообщение об ошибке (error message) может иметь длину до 255 символов в кодировке Unicode.
--     Сообщения об ошибках SQL Server перечислены в представлении каталога
-- sys.messages.
--     Можно добавлять пользовательские сообщения об ошибках с помощью про-
-- цедуры sp_addmessage.


-- Пример генерации ошибки:
-- RAISERROR ('Error in %s stored procedure', 16, 0, N'usp_InsertCategories');
-- Или с помощью текстовой переменной и функции FROMATMESSAGE():
-- DECLARE @message AS NVARCHAR(1000) = 'Error in %s stored procedure';
-- SELECT @message = FORMATMESSAGE (@message, N'usp_InsertCategories');
-- RAISERROR (@message, 16, 0);


-- Команда THROW:
-- THROW 50000, 'Error in usp_InsertCategories stored procedure', 0;

-- Поскольку инструкция THROW не позволяет форматировать параметр сообщения,
-- можно использовать функцию FORMATMESSAGE()
-- DECLARE @message AS NVARCHAR(1000) = 'Error in %s stored procedure';
-- SELECT @message = FORMATMESSAGE(@message, N'usp_InsertCategories');
-- THROW 50000, @message, 0;

-- Команда RAISERROR, как правило, не завершает работу пакета. Тогда как команда THROW завершает пакет.



-- @@ERROR системная функция. При успешном завершении инструкции значение @@ERROR будет равно 0, в противном случае @@ERROR будет содержать номер ошибки.
-- Любой запрос функции @@ERROR, даже если это делается в предложении IF, приводит к ее сбросу и присвоению нового номера, 
-- потому что @@ERROR всегда выводит состояние ошибки последней выполненной команды. Поэтому проверить значение @@ERROR внутри кода управления ошибкой невозможно. 
-- Лучше добавить код, который сохраняет значение @@ERROR в переменной, и затем проверять эту переменную.

-- XACT_ABORT. Поставив в начало пакета SET XACT_ABORT ON, можно вызвать сбой всего этого
-- пакета в случае возникновения ошибки. XACT_ABORT устанавливается на отдельный
-- сеанс. После его установки в ON, ему подчиняются все остальные транзакции в этом
-- сеансе до того, как он будет установлен в OFF.
-- Нельзя перехватить ошибку или получить номер ошибки;
-- Любая ошибка с уровнем серьезности более 10 приводит к откату транзакции;



-- TRY..CATCH. Ошибки с уровнем серьезности больше 10 и меньше 20, ошибки с уровнем серьезности 20 и больше, 
-- которые не закрывают соединения, в блоке TRY приводят к передаче управления блоку CATCH.
-- В блоке CATCH можно выполнить фиксацию или откат текущей транзакции, если
-- транзакция не может быть зафиксирована и ее необходимо откатить. Для проверки состояния транзакции можно запросить функцию XACT_STATE.

-- Для того чтобы создать сообщение об ошибке, можно использовать следующий
-- набор функций внутри блока CATCH:
-- ERROR_NUMBER — возвращает номер ошибки;
-- ERROR_MESSAGE — возвращает сообщение об ошибке;
-- ERROR_SEVERITY — возвращает уровень серьезности ошибки;
-- ERROR_LINE — возвращает номер строки в пакете, где произошла ошибка;
-- ERROR_PROCEDURE — имя функции, триггера или процедуры, которые выполнялись в момент возникновения ошибки;
-- ERROR_STATE — состояние ошибки.
-- Можно инкапсулировать вызовы этих функций в хранимую процедуру, а затем вызывать хранимую процедуру из различных блоков CATCH:
-- BEGIN CATCH
--     -- Обработка ошибок
--     SELECT ERROR_NUMBER() AS errornumber
--     , ERROR_MESSAGE() AS errormessage
--     , ERROR_LINE() AS errorline
--     , ERROR_SEVERITY() AS errorseverity
--     , ERROR_STATE() AS errorstate;
-- END CATCH;



-- В следующем коде вы будете проверять значение инструкции @@ERROR немедленно после того, как выполнилась инструкция модификации данных
-- USE TSQLV4;
-- GO
-- DECLARE @errnum AS int;
-- BEGIN TRAN;
--     SET IDENTITY_INSERT Production.Products ON;                             --вставка значений в этот столбец с автоинкрементным идентификатором не вызовет ошибки, и вставленные значения будут использоваться вместо автоинкрементных значений
--     INSERT INTO Production.Products(productid, productname, supplierid,
--             categoryid, unitprice, discontinued)
--     VALUES(1, N'Test1: Duplicate productid', 1, 1, 18.00, 0);
--     SET @errnum = @@ERROR;
--     IF @errnum <> 0 -- Обработка ошибки
--         BEGIN
--             PRINT 'Insert into Production.Products failed with error ' +
--                 CAST(@errnum AS VARCHAR);
--         END;
-- GO
-- IF @@TRANCOUNT <> 0 ROLLBACK TRANSACTION



-- На этом шаге вы будете работать с неструктурированной обработкой ошибок в
-- транзакции. В следующем коде есть две инструкции INSERT в пакете, которые вы
-- поместите в транзакцию для того, чтобы выполнить откат транзакции в случае
-- сбоя любой из инструкций. Первая инструкция INSERT завершается сбоем, но
-- вторая выполняется успешно, поскольку SQL Server по умолчанию не выполня-
-- ет откат транзакции с ошибкой повторяющегося первичного ключа. Заметьте,
-- при выполнении кода первая инструкция INSERT завершается ошибкой из-за на-
-- рушения ограничения первичного ключа, и транзакция откачена. Но вторая ин-
-- струкция INSERT заканчивается успешно, потому что неструктурированная обра-
-- ботка ошибок не передает управление программой таким образом, чтобы не вы-
-- полнять вторую инструкцию INSERT. 

-- USE TSQLV4;
-- GO

-- DECLARE @errnum AS int;
-- BEGIN TRAN;
-- SET IDENTITY_INSERT Production.Products ON;

-- -- Вставка #1 не выполнится из-за повторяющегося первичного ключа
-- INSERT INTO Production.Products(productid, productname, supplierid,
--     categoryid, unitprice, discontinued)
-- VALUES(1, N'Test1: Duplicate productid', 1, 1, 18.00, 0);

-- SET @errnum = @@ERROR;
-- IF @errnum <> 0
-- BEGIN
--     IF @@TRANCOUNT > 0 ROLLBACK TRAN;
--     PRINT 'Insert #1 into Production.Products failed with error ' +
--         CAST(@errnum AS VARCHAR);
-- END;

-- -- Вставка #2 будет успешной
-- INSERT INTO Production.Products(productid, productname, supplierid,
--     categoryid, unitprice, discontinued)
-- VALUES(101, N'Test2: New productid', 1, 1, 18.00, 0);

-- SET @errnum = @@ERROR;
-- IF @errnum <> 0
-- BEGIN
--     IF @@TRANCOUNT > 0 ROLLBACK TRAN;
--     PRINT 'Insert #2 into Production.Products failed with error ' +
--         CAST(@errnum AS VARCHAR);
-- END;

-- SET IDENTITY_INSERT Production.Products OFF;

-- IF @@TRANCOUNT > 0 COMMIT TRAN;

-- -- Удаление вставленной строки
-- DELETE FROM Production.Products WHERE productid = 101;

-- PRINT 'Deleted ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows'; -- Функция @@ROWCOUNT возвращает количество строк, затронутых последним оператором DML.


-- ***************************************************

-- USE TSQLV4;
-- GO
-- SET XACT_ABORT ON;
-- PRINT 'Before error';                        -- до ошибки
-- SET IDENTITY_INSERT Production.Products ON;
-- INSERT INTO Production.Products(productid, productname, supplierid,
-- categoryid, unitprice, discontinued)
-- VALUES(1, N'Test1: Duplicate productid', 1, 1, 18.00, 0);
-- SET IDENTITY_INSERT Production.Products OFF;
-- PRINT 'After error';                         -- после ошибки (не выведется, так как из-за SET XACT_ABORT ON пакет будет прерван)
-- GO
-- PRINT 'New batch';                           -- это выведется, так как это новый пакет
-- SET XACT_ABORT OFF;

-- **********************************************************************************

-- USE TSQLV4;
-- GO
-- SET XACT_ABORT ON;
-- PRINT 'Before error';                                               -- выведется
-- THROW 50000, 'Error in usp_InsertCategories stored procedure', 0;   -- снова пакет прерываеся из-за SET XACT_ABORT ON
-- PRINT 'After error';                                                -- не выведется
-- GO
-- PRINT 'New batch';                                                  -- выведется
-- SET XACT_ABORT OFF;

-- ********************************************************************************

-- USE TSQLV4;
-- GO

-- DECLARE @errnum AS int;
-- SET XACT_ABORT ON;

-- BEGIN TRAN;
-- SET IDENTITY_INSERT Production.Products ON;

-- -- Вставка #1 не выполнится из-за повторяющегося первичного ключа
-- INSERT INTO Production.Products(productid, productname, supplierid, categoryid, unitprice, discontinued)
-- VALUES(1, N'Test1: Duplicate productid', 1, 1, 18.00, 0);

-- SET @errnum = @@ERROR;          -- это уже не выполнится
-- IF @errnum <> 0
-- BEGIN
--     IF @@TRANCOUNT > 0 ROLLBACK TRAN;
--     PRINT 'Error in first INSERT';
-- END;

-- -- Вставка #2 больше не выполняется
-- INSERT INTO Production.Products(productid, productname, supplierid, categoryid, unitprice, discontinued)
-- VALUES(101, N'Test2: New productid', 1, 1, 18.00, 0);

-- SET @errnum = @@ERROR;
-- IF @errnum <> 0
-- BEGIN
--     -- Принятие мер с учетом ошибок
--     IF @@TRANCOUNT > 0 ROLLBACK TRAN;
--     PRINT 'Error in second INSERT';
-- END;

-- SET IDENTITY_INSERT Production.Products OFF;

-- IF @@TRANCOUNT > 0 COMMIT TRAN;
-- GO

-- DELETE FROM Production.Products WHERE productid = 101;
-- PRINT 'Deleted ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows';

-- SET XACT_ABORT OFF;
-- GO

-- SELECT XACT_STATE(), @@TRANCOUNT;

-- ************************************************************************************

-- Пример TRY CATCH:

-- USE TSQL2012;
-- GO

-- BEGIN TRY
--     BEGIN TRAN;
--     SET IDENTITY_INSERT Production.Products ON;

--     INSERT INTO Production.Products(productid, productname, supplierid, categoryid, unitprice, discontinued)
--     VALUES(1, N'Test1: Duplicate productid', 1, 1, 18.00, 0);

--     INSERT INTO Production.Products(productid, productname, categoryid, unitprice, discontinued)
--     VALUES(101, N'Test2: New productid', 1, 10, 18.00);

--     SET IDENTITY_INSERT Production.Products OFF;
--     COMMIT TRAN;
-- END TRY
-- BEGIN CATCH
--     SELECT XACT_STATE() AS 'XACT_STATE', @@TRANCOUNT AS '@@TRANCOUNT';
--     IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--     THROW;
-- END CATCH;
-- GO
-- SELECT XACT_STATE() AS 'XACT_STATE', @@TRANCOUNT AS '@@TRANCOUNT';