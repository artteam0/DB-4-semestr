use UNIVER1

exec sp_helpindex 'AUDITORIUM';
exec sp_helpindex 'AUDITORIUM_TYPE';
exec sp_helpindex 'FACULTY';
exec sp_helpindex 'PROFESSION';
exec sp_helpindex 'PROGRESS';
exec sp_helpindex 'PULPIT';
exec sp_helpindex 'STUDENT';
exec sp_helpindex 'SUBJECT';
exec sp_helpindex 'TEACHER';	

DROP TABLE IF EXISTS #TableEx1;

create table #TableEx1
(
	ID int,
	Name varchar(20),
);

declare @i int = 1;
set nocount on;           
while @i < 10000
	begin
insert #TableEx1(ID, Name)
	values(@i, CONCAT('Name_', @i))
set @i = @i + 1;
	end

drop index IX_TableEx1_ID on #TableEx1;
select * 
from #TableEx1
where #TableEx1.ID between 500 and 8500; --0,002
checkpoint;
dbcc DROPCLEANBUFFERS;

create clustered index IX_TableEx1_ID on #TableEx1 (ID) --0.001

select * 
from #TableEx1
where #TableEx1.ID between 500 and 8500;

--2
create table #TableEx2
(
	ID int,
	Name varchar(20),
	CC int identity(1, 1),
);

go
declare @i int = 1;
set nocount on;           
while @i < 50000
	begin
insert #TableEx2(ID, Name)
	values(@i, CONCAT('Name_', @i))
set @i = @i + 1;
	end

drop index #TableEx2_NONCLY on #TableEx2;
create index #TableEx2_NONCLY on #TableEx2(CC);

select * from #TableEx2 where ID > 500 and CC < 1000;
select * from #TableEx2	order by Id, Name;
select * from #TableEx2 where ID > 500 and CC = 5;

--3
create table #TableEx3
(
	ID int,
	Name varchar(20),
	CC int identity(1, 2),
);

go
declare @i int = 1;
set nocount on;           
while @i < 50000
	begin
insert #TableEx3(ID, Name)
	values(@i, CONCAT('Name_', @i))
set @i = @i + 1;
	end

select * from #TableEx3 where ID > 1250

create index #TableEx3_ID on #TableEx3(CC) include (ID, Name);

select * from #TableEx3 where CC > 50;
drop index #TableEx3_ID on #TableEx3;

--4
create table #TableEx4
(
	ID int,
	Name varchar(20),
	CC int identity(1, 2),
);

go
declare @i int = 1;
set nocount on;           
while @i < 50000
	begin
insert #TableEx4(ID, Name)
	values(@i, CONCAT('Name_', @i))
set @i = @i + 1;
	end

select ID from #TableEx4 where ID between 12000 and 49901;
select ID from #TableEx4 where ID > 12000 and ID < 49901;
select ID from #TableEx4 where ID = 49901;

create index #TableEx4_Id on #TableEx4(ID) where (ID > 25000 and  ID < 50000)
select ID from #TableEx4 where ID between 12000 and 49901;
select ID from #TableEx4 where ID > 12000 and ID < 19000;
select ID from #TableEx4 where ID = 49901;

--5
create table #TableEx5
(
	ID int,
	Name varchar(20),
	CC int identity(1, 2),
);

go
declare @i int = 1;
set nocount on;           
while @i < 100000
	begin
insert #TableEx5(ID, Name)
	values(@i, CONCAT('Name_', @i))
set @i = @i + 1;
	end

drop index #TableEx5_ID on #TableEx5;
create index #TableEx5_ID on #TableEx5(ID);

SELECT 'После создания' AS Этап, name AS [Индекс], avg_fragmentation_in_percent AS [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'tempdb..#TableEx5'), NULL, NULL, NULL) ss
JOIN tempdb.sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id
WHERE ii.name IS NOT NULL;

DELETE FROM #TableEx5 WHERE ID % 2 = 0;
DECLARE @j INT = 100000;
WHILE @j < 150000
BEGIN
    INSERT #TableEx5(ID, Name)
    VALUES(CAST(RAND()*200000 AS INT), CONCAT('Name_', @j));
    SET @j = @j + 1;
END;

SELECT 'После создания фрагментации' AS Этап, name AS [Индекс], avg_fragmentation_in_percent AS [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'tempdb..#TableEx5'), NULL, NULL, NULL) ss
JOIN tempdb.sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id
WHERE ii.name IS NOT NULL;

alter index #TableEx5_ID on #TableEx5 reorganize;

SELECT 'После реорганизации' AS Этап, name AS [Индекс], avg_fragmentation_in_percent AS [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'tempdb..#TableEx5'), NULL, NULL, NULL) ss
JOIN tempdb.sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id
WHERE ii.name IS NOT NULL;

alter index #TableEx5_ID on #TableEx5 rebuild with (online = off);

SELECT 'После перестройки' AS Этап, name AS [Индекс], avg_fragmentation_in_percent AS [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'tempdb..#TableEx5'), NULL, NULL, NULL) ss
JOIN tempdb.sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id
WHERE ii.name IS NOT NULL;

--6
create table #TableEx6
(
	ID int,
	Name varchar(20),
	CC int identity(1, 2),
);

go
declare @i int = 1;
set nocount on;           
while @i < 100000
	begin
insert #TableEx6(ID, Name)
	values(@i, CONCAT('Name_', @i))
set @i = @i + 1;
	end

go
DELETE FROM #TableEx6 WHERE ID % 2 = 0;
DECLARE @j INT = 100000;
WHILE @j < 150000
BEGIN
    INSERT #TableEx6(ID, Name)
    VALUES(CAST(RAND()*200000 AS INT), CONCAT('Name_', @j));
    SET @j = @j + 1;
END;

SELECT 'После создания' AS Этап, name AS [Индекс], avg_fragmentation_in_percent AS [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'tempdb..#TableEx6'), NULL, NULL, NULL) ss
JOIN tempdb.sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id
WHERE ii.name IS NOT NULL;

drop index #TableEx6_ID on #TableEx6;
create index #TableEx6_ID on #TableEx6(ID) with (fillfactor = 65);

SELECT 'После fillfactor' AS Этап, name AS [Индекс], avg_fragmentation_in_percent AS [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'tempdb..#TableEx6'), NULL, NULL, NULL) ss
JOIN tempdb.sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id
WHERE ii.name IS NOT NULL;

--7
use lab042;

select * from студенты;
select * from предметы;
select * from записи_на_факультативы;

drop index if exists #St_Fam on студенты;
drop index if exists #Pred_Lab on предметы;
drop index if exists #Rec_Ocenka on записи_на_факультативы;

select * from студенты where фамилия like 'С%';
select * from предметы where объем_лабораторных_работ > 30;
select * from записи_на_факультативы where оценка >= 8;

create index #St_Fam on студенты(фамилия);
select * from студенты where фамилия like 'С%';

create index #Pred_Lab on предметы(объем_лабораторных_работ);
select * from предметы where объем_лабораторных_работ > 30;

create index #Rec_Ocenka on записи_на_факультативы(оценка);
select * from записи_на_факультативы where оценка >= 8;

create index #Rec_full on записи_на_факультативы(номер_студента, номер_предмета, оценка);
create index #Rec_pred_with_ocenka on записи_на_факультативы(номер_предмета) include (оценка);
create index #Pred_name_full on предметы(название_предмета, объем_лекций, объем_практических_занятий, объем_лабораторных_работ);
create index #St_addr_with_phone on студенты(адрес) include (номер_телефона);
