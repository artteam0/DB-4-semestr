use lab042;
--4
BEGIN TRANSACTION;
UPDATE записи_на_факультативы
SET оценка = 1
WHERE номер_студента = 1 AND номер_предмета = 1;
ROLLBACK;

--5
BEGIN TRANSACTION;
UPDATE записи_на_факультативы
SET оценка = 10
WHERE номер_студента = 1 AND номер_предмета = 1;
COMMIT;

--6
BEGIN TRANSACTION;
UPDATE записи_на_факультативы
SET оценка = 5
WHERE номер_студента = 1 AND номер_предмета = 1;
COMMIT;

--7
BEGIN TRANSACTION;

INSERT INTO записи_на_факультативы (номер_записи, номер_предмета, номер_студента, оценка)
VALUES (999, 1, 1, 8);
ROLLBACK;
