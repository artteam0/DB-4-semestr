--1
declare @char char='a',
		@varchar varchar(4)='БГТУ';
declare @datetime datetime;
declare @time time;
declare @int int;
declare @smallint smallint;
declare @tint tinyint;
declare @numeric numeric(12, 5) = 1234567.12345;

set @datetime=getdate();
set @int=52;
set @smallint=5;
set @tint=1;
select @time='08:39:21';
select @char as char, @varchar as varchar, @datetime as datetime, @time as time;
print 'int= ' + convert(varchar, @int);
print 'smallint= ' + convert(varchar, @smallint);
print 'numeric= ' + convert(varchar, @numeric);

--2
use UNIVER2
declare @resSum int=(select sum(a.AUDITORIUM_CAPACITY) from AUDITORIUM a);
if (@resSum>=200)
begin
	declare @countAuditorium int=(select count(*) from AUDITORIUM);
	declare @avgCapacity int=(select avg(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM);
	declare @countBelow int=(select count(*) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY<@avgCapacity);
	declare @precentBelowAvg numeric(5,2)=cast(@countBelow as float)/@countAuditorium*100;

print 'количество аудиторий: '+convert(varchar, @countAuditorium);
print 'среднаяя вместимость аудиторий: '+convert(varchar, @avgCapacity);
print 'количество аудиторий, сместимость которых меньше средней: '+convert(varchar, @countBelow);
print 'процент этих аудиторий: '+convert(varchar, @precentBelowAvg);
end

else print 'общая сумма: '+convert(varchar, @resSum);

--3
print '-@@ROWCOUNT (число обработанных строк): '+convert(varchar, @@ROWCOUNT);
print '-@@VERSION (версия SQL Sevver): '+convert(varchar, @@VERSION);
print '-@@SPID (системный идентификатор процесса): '+convert(varchar, @@SPID);
print '-@@ERROR (код последней ошибки): '+convert(varchar, @@ERROR);
print '-@@SERVERNAME (имя сервера): '+convert(varchar, @@SERVERNAME);
begin tran;
print '-@@TRANCOUNT (уровень вложенности транзакции): '+convert(varchar, @@TRANCOUNT);
rollback;
print '-@@FETCH_STATUS (результат FETCH): '+convert(varchar ,@@FETCH_STATUS);
print '-@@NESTLEVEL (уровень вложенности процедуры): '+convert(varchar, @@NESTLEVEL);

--4
declare @t float = 3.0;
declare @x float = 2.0;
declare @z float;
if (@t>@x)set @z=power(sin(@t),2);
else if (@t<@x) set @z=4*(@t+@x);
else set @z=1-exp(@x-2);
print '@z = '+convert(varchar, @z);

select NAME as Полное_ФИО,
LEFT(NAME, charindex(' ', NAME) - 1) + ' ' + 
substring(NAME, charindex(' ', NAME) + 1, 1) + '.' + ' ' + 
substring(NAME, charindex(' ', NAME, charindex(' ', NAME) + 1) + 1, 1) + '.' as Сокращенное_ФИО
from STUDENT;

declare @dweek int=(select datepart(weekday, PROGRESS.PDATE) as DayOfWeek from PROGRESS
where PROGRESS.SUBJECT like 'СУБД' and PROGRESS.IDSTUDENT = 1016);
print '@dweek: '+convert(varchar, @dweek);

declare @bday int=(select avg(STUDENT.IDSTUDENT) from STUDENT
where month(STUDENT.BDAY) = month(dateadd(month,1,getdate())));
print '@bday: '+convert(varchar, @bday);

--5
use lab042
declare @negmark int;
select @negmark=count(*) from записи_на_факультативы where оценка<4;
if @negmark>0 
print 'есть студенты с неудовлетворительной оценкой';
else print 'нет студентов с неудовлетворительными оценками';

--6
use UNIVER1
--select * from PROGRESS;
select case 
	when p.NOTE > 9 then '1.6'
	when p.NOTE between 8 and 9 then '1.4'
	when p.NOTE between 6 and 8 then '1.2'
	when p.NOTE between 5 and 6 then '1.0'
	else 'без стипендии'
	end Оценка, p.IDSTUDENT
from PROGRESS p
where p.SUBJECT like 'СУБД'

--7
create table #example (
    ID int,
    name nvarchar(50),
    mark int);
declare @i int=1;
while @i<=10 
begin
	insert into #example(ID, name, mark)
	values(@i,'artsiom'+convert(nvarchar, @i), @i*10);
	set @i=@i+1;
end
select * from #example;

--8
declare @y int=10;
print @y+5;
print @y+10;
return;
print @y+20
print '@xyy = ' + convert(varchar, @y);

--9
begin try
declare @q int=10/0;
end try
begin catch
print 'код последней ошибки: '+convert(varchar, error_number());
print 'сообщение об ошибке: '+convert(varchar, error_message());
print 'номер строки с ошибкой: '+convert(varchar, error_line());
print 'имя процедуры или null: '+convert(varchar, error_procedure());
print 'уровень сереьезности ошибки: '+convert(varchar, error_severity());
print 'метка ошибки: '+convert(varchar, error_state());
end catch