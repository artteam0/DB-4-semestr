USE lab042;
SET NOCOUNT ON;
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'dbo.lab12'))
    DROP TABLE lab12;
DECLARE @c INT, @flag CHAR = 'c';
SET IMPLICIT_TRANSACTIONS ON;

CREATE TABLE lab12 (
Id INT,
surname NVARCHAR(50)
);

INSERT INTO lab12 VALUES
(1, 'Кулешов'),
(2, 'Рауба'),
(3, 'Дмитроченко'),
(4, 'Лужецкий'),
(5, 'Статько');
SET @c = (SELECT COUNT(*) FROM lab12);
PRINT 'всего студентов: ' + CAST(@c AS VARCHAR(2));
IF @flag = 'c' COMMIT ELSE ROLLBACK;
SET IMPLICIT_TRANSACTIONS OFF;
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'dbo.lab12'))
    PRINT 'lab12 есть'
ELSE
    PRINT 'lab12 нет';

--2
BEGIN TRY
    BEGIN TRAN
        DELETE FROM записи_на_факультативы WHERE номер_предмета = 2;
        INSERT INTO записи_на_факультативы VALUES (100, 2, 1, 10);
    COMMIT TRAN;
END TRY
BEGIN CATCH
    PRINT 'Ошибка: ' + CASE
        WHEN ERROR_NUMBER() = 2627 AND PATINDEX('%PK_%', ERROR_MESSAGE()) > 0 THEN 'дублирование ключа'
        ELSE 'неизвестная ошибка: ' + CAST(ERROR_NUMBER() AS VARCHAR(5)) + ERROR_MESSAGE()
    END;
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
END CATCH;

--3
DECLARE @point VARCHAR(32);

BEGIN TRY
    BEGIN TRAN
        INSERT INTO записи_на_факультативы VALUES (101, 3, 1, 7);
        SET @point = 'p1'; SAVE TRAN @point;

        INSERT INTO записи_на_факультативы VALUES (102, 3, 2, 8);
        SET @point = 'p2'; SAVE TRAN @point;

        INSERT INTO записи_на_факультативы VALUES (103, 3, 3, 9);
    COMMIT TRAN;
END TRY
BEGIN CATCH
    PRINT 'Ошибка: ' + CASE
        WHEN ERROR_NUMBER() = 2627 AND PATINDEX('%PK_%', ERROR_MESSAGE()) > 0 THEN 'дублирование ключа'
        ELSE 'неизвестная ошибка: ' + CAST(ERROR_NUMBER() AS VARCHAR(5)) + ERROR_MESSAGE()
    END;
    IF @@TRANCOUNT > 0
    BEGIN
        PRINT 'Контрольная точка: ' + @point;
        ROLLBACK TRAN @point;
        COMMIT TRAN;
    END;
END CATCH;

--4
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
SELECT * FROM записи_на_факультативы WHERE номер_студента = 1;
ROLLBACK;


--5
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
SELECT * FROM записи_на_факультативы WHERE номер_студента = 1;
SELECT * FROM записи_на_факультативы WHERE оценка >= 7;
COMMIT;

--6
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT * FROM записи_на_факультативы WHERE номер_студента = 1;
SELECT * FROM записи_на_факультативы WHERE оценка >= 7;
COMMIT;

--7
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SELECT * FROM записи_на_факультативы WHERE номер_студента = 1;
SELECT * FROM записи_на_факультативы WHERE оценка >= 7;
COMMIT;

--8
BEGIN TRANSACTION;
UPDATE записи_на_факультативы
SET оценка = 1
WHERE номер_студента = 1;
SAVE TRANSACTION Point;

UPDATE записи_на_факультативы
SET оценка = 10
WHERE номер_студента = 2;
SELECT * FROM записи_на_факультативы;
ROLLBACK TRANSACTION Point;
SELECT * FROM записи_на_факультативы;
COMMIT;
