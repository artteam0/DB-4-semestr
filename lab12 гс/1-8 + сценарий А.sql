use UNIVER1;

set nocount on;
if exists(select*from sys.objects where OBJECT_ID=object_id(N'dbo.lab12'))
drop table lab12;

declare @c int, @flag char='c';
set implicit_transactions on;
create table lab12(
Id int,
surname nvarchar(50)
);

insert into lab12 values
(1, 'Кулешов'),
(2,'Рауба'),
(3,'Дмитроченко'),
(4, 'Лужецкий'),
(5, 'Статько');

set @c=(select count(*) from lab12);
print 'Всего студентов: '+cast(@c as varchar(2));
if @flag='c' commit
else rollback;
set implicit_transactions off;

if exists(
select*from sys.objects where OBJECT_ID=object_id(N'dbo.lab12')
)
print 'lab12 есть'
else print 'lab12 нет';

--2
begin try
begin tran
delete PULPIT where FACULTY like 'ФММП';
insert PULPIT values ('ЛВ', 'Лесоводства', 'ЛХФ');
commit tran;
end try
begin catch
print 'ошибка: '+case
	when error_number()=2627 and patindex('%PK_PULPIT%', error_message())>0
	then 'дублирование товара'
	else 'неизвестная ошибка: '+cast(error_number() as varchar(5))+error_message()
   end;
  if @@trancount >0 rollback tran;
end catch;	

--3
declare @point varchar(32);
begin try
	begin tran
		insert PUlPIT values('ccc', 'CCC', 'ЛХФ');
		set @point='p1'; save tran @point;
		insert PUlPIT values('aaa', 'AAA', 'ИЭФ');
		set @point='p2'; save tran @point;
		insert PUlPIT values('bbb', 'BBB', 'ТОВ');
	commit tran;
end try
begin catch
	print 'ошибка: '+case
	when error_number()=2627 and patindex('%PK_PULPIT%', error_message())>0
	then 'дублирование товара'
	else 'неизвестная ошибка: '+cast(error_number() as varchar(5))+error_message()
	end;
	if @@trancount > 0
	begin
		print 'котнтрольная точка: '+@point;
		rollback tran @point;
		commit tran;
	end;
end catch

--4
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
SELECT * FROM AUDITORIUM WHERE AUDITORIUM = '236-1';

ROLLBACK;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
SELECT * FROM AUDITORIUM WHERE AUDITORIUM = '236-1';

--5
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
SELECT * FROM AUDITORIUM WHERE AUDITORIUM = '236-1';
SELECT * FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY >= 30;
COMMIT;

--6
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT * FROM AUDITORIUM WHERE AUDITORIUM = '236-1';
SELECT * FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY >= 30;
COMMIT;
delete from AUDITORIUM where AUDITORIUM like '8888-8'
delete from AUDITORIUM where AUDITORIUM like '7777-7'
rollback;
--7
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SELECT * FROM AUDITORIUM WHERE AUDITORIUM = '236-1';
SELECT * FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY >= 30;
COMMIT;

--8
BEGIN TRANSACTION;
UPDATE AUDITORIUM
SET AUDITORIUM_NAME = 'аудитория'
WHERE AUDITORIUM = '206-1';
SAVE TRANSACTION Point;
UPDATE AUDITORIUM
SET AUDITORIUM_CAPACITY = 300
WHERE AUDITORIUM = '206-1';
SELECT * FROM AUDITORIUM WHERE AUDITORIUM = '206-1';
ROLLBACK TRANSACTION Point;
SELECT * FROM AUDITORIUM WHERE AUDITORIUM = '206-1';
COMMIT;
