use lab042

go
create function dbo.fullname(@numstud int) returns nvarchar(50)
as begin
	declare @rc nvarchar(50);
	select @rc = фамилия+' '+LEFT(имя, 1)+'. '+LEFT(отчество, 1)+'.'
	from студенты
	where номер_студента=@numstud;
	return @rc;
end;

go
select dbo.fullname(7) as 'фио 7 студента: ';

go
create function dbo.hourss(@subid int) returns int
as begin
	declare @rc int =0;
	select @rc=объем_лекций+объем_лабораторных_работ+объем_практических_занятий from предметы
	where номер_предмета=@subid
	return @rc;
end

go
select dbo.hourss(3) as 'всего часов по 3 предмету: ';

go
create function dbo.avggrade(@studid int) returns float
as begin
	declare @rc float = 0;
	select @rc=avg(cast(записи_на_факультативы.оценка as float)) from записи_на_факультативы
	where номер_студента=@studid
	return @rc;
end

go
select dbo.avggrade(2) as 'средняя оценка 2 студента: ';


go
create function dbo.howmuch(@subjid int) returns int
as begin
	declare @rc int =0;
	select @rc = count(записи_на_факультативы.номер_студента)
	from записи_на_факультативы
	where номер_предмета=@subjid
	return @rc;
end

go
select dbo.howmuch(1) as 'сколько студентов на 1 предмете: ';


go
create function dbo.tablefirst(@studid int) returns table
as return
	select предметы.название_предмета, записи_на_факультативы.оценка
	from записи_на_факультативы join предметы on записи_на_факультативы.номер_предмета=предметы.номер_предмета
	where номер_студента=@studid;

go
select * from dbo.tablefirst(1);


go
create function dbo.tablesec(@subjname int) returns table
as return
	select студенты.фамилия, студенты.адрес, студенты.номер_телефона
	from студенты join записи_на_факультативы on студенты.номер_студента=записи_на_факультативы.номер_студента
				  join предметы on записи_на_факультативы.номер_предмета=предметы.номер_предмета
	where предметы.номер_предмета=@subjname

go
select * from dbo.tablesec(1);


go
create function dbo.tablethird(@address nvarchar(50)) returns table
as return
	select * from студенты where адрес=@address

go
select * from dbo.tablethird('Бобруйская');