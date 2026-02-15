use UNIVER2

go
create function COUNT_STUDENTS (@faculty varchar(20)) returns int
as begin
	declare @rc int=0;
	set @rc = (select count(s.NAME) from STUDENT s join GROUPS g on s.IDGROUP = g.IDGROUP join FACULTY f on g.FACULTY = f.FACULTY where f.FACULTY = @faculty);
	return @rc;
end;
go

declare @faculty varchar(20) = 'ИДиП';
declare @ex1 int = dbo.COUNT_STUDENTS(@faculty);
print 'количество студентов на факультете ' + @faculty + ': '+ cast(@ex1 as varchar(2));


go
create function FSUBJECTS(@p varchar(20)) returns char(300)
as begin
	declare @tv char(20);
	declare @t char(300)='Дисциплина';
	declare curs cursor local static
	for select s.SUBJECT from SUBJECT s join PULPIT p on s.PULPIT=p.PULPIT where FACULTY=@p;
open curs;
fetch curs into @tv;
while @@FETCH_STATUS=0
	begin 
		set @t=@t+', '+rtrim(@t);
		fetch curs into @tv;
	end;
close curs;
return @t;
end;

go
SELECT FACULTY, dbo.FSUBJECTS(FACULTY) AS [Дисциплины по факультету]
FROM FACULTY;


go
create function FFACPUL (@fac varchar(20), @pul varchar(20)) 
returns table
as return 
	select f.FACULTY, p.PULPIT from FACULTY f join PULPIT p on f.FACULTY = p.FACULTY 
	where f.FACULTY = ISNULL(@fac, f.FACULTY) and p.PULPIT = ISNULL(@pul, p.PULPIT);
go

select * from dbo.FFACPUL(NULL, NULL);
select * from dbo.FFACPUL('ЛХФ', NULL);
select * from dbo.FFACPUL(NULL, 'ИВД');
go

go
create function FCTEACHER (@p varchar(20)) 
returns int 
as
begin 
	declare @rc int = (select count(t.TEACHER_NAME) 
	from PULPIT p join TEACHER t on p.PULPIT = t.PULPIT
	where p.PULPIT = ISNULL(@p, p.PULPIT));
	return @rc;
end;
go

select PULPIT, dbo.FCTEACHER(PULPIT) as [Количество преподавателей] from PULPIT


--6
---
use UNIVER2
          create function FACULTY_REPORT(@c int) returns @fr table
                          ( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
                                                                   [Количество студентов] int, [Количество специальностей] int )
  as begin 
                 declare cc CURSOR static for 
         select FACULTY from FACULTY 
                                                    where dbo.COUNT_STUDENTS(FACULTY, default) > @c; 
         declare @f varchar(30);
         open cc;  
                 fetch cc into @f;
         while @@fetch_status = 0
         begin
              insert @fr values( @f,  (select count(PULPIT) from PULPIT where FACULTY = @f),
              (select count(IDGROUP) from GROUPS where FACULTY = @f),   dbo.COUNT_STUDENTS(@f, default),
              (select count(PROFESSION) from PROFESSION where FACULTY = @f)   ); 
              fetch cc into @f;  
         end;   
                 return; 
  end;

go
------------
create or alter function COUNT_GROUP (@group varchar(20)) returns int 
as begin declare @rc int = 0;
  set @rc = (select COUNT(g.IDGROUP) from STUDENT s join GROUPS g on s.IDGROUP = g.IDGROUP join FACULTY f on g.FACULTY = f.FACULTY join PROFESSION p on f.FACULTY = p.FACULTY where f.FACULTY = @group);
  return @rc;
end;
go
go
create or alter function COUNT_PROFESSION (@faculty varchar(20)) returns int 
as begin declare @rc int = 0;
  set @rc = (select COUNT(p.PROFESSION) from STUDENT s join GROUPS g on s.IDGROUP = g.IDGROUP join FACULTY f on g.FACULTY = f.FACULTY join PROFESSION p on f.FACULTY = p.FACULTY where f.FACULTY = @faculty);
  return @rc;
end;
go
create or alter function COUNT_PULPIT (@pulpit varchar(20)) returns int 
as begin declare @rc int = 0;
  set @rc = (select COUNT(p.PROFESSION) from STUDENT s join GROUPS g on s.IDGROUP = g.IDGROUP join FACULTY f on g.FACULTY = f.FACULTY join PROFESSION p on f.FACULTY = p.FACULTY join PULPIT pul on pul.FACULTY = f.FACULTY where f.FACULTY = @pulpit);
  return @rc;
end;
go
create or alter function COUNT_STUDENTS (@pulpit varchar(20)) returns int
as begin declare @rc int = 0
  set @rc = (select count(IDSTUDENT) from STUDENT s join GROUPS g on s.IDGROUP = g.IDGROUP join FACULTY f on g.FACULTY = f.FACULTY join PROFESSION p on f.FACULTY = p.FACULTY join PULPIT pul on pul.FACULTY = f.FACULTY where f.FACULTY = @pulpit);
  return @rc;
end;
go
create or alter function FACULTY_REPORT(@c int) returns @fr table
                          ( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
                                                                   [Количество студентов] int, [Количество специальностей] int )
  as begin 
                 declare cc CURSOR static for 
         select FACULTY from FACULTY 
       where dbo.COUNT_STUDENTS(FACULTY) > @c; 
         declare @f varchar(30);
         open cc;  
                 fetch cc into @f;
         while @@fetch_status = 0
         begin
              insert @fr values( @f,  
        dbo.COUNT_PULPIT(@f),
        dbo.COUNT_GROUP(@f),
        dbo.COUNT_PROFESSION(@f),
        dbo.COUNT_PROFESSION(@f));
              fetch cc into @f;  
         end;
       close cc;
       deallocate cc;
                 return; 
  end;

go

SELECT * FROM dbo.FACULTY_REPORT(0);


use lab042
go
create function dbo.студентыпредмет (@название_предмета nvarchar(50))
returns int
as
begin
    declare @количество int = 0;
    select @количество = count(distinct знф.номер_студента)
    from записи_на_факультативы знф
    inner join предметы п on знф.номер_предмета = п.номер_предмета
    where п.название_предмета = @название_предмета;
    return @количество;
end;
go

select dbo.студентыпредмет('математика') as студенты_на_математике;
select dbo.студентыпредмет('химия') as студенты_на_химии;
go

go
create function dbo.студентыпредметы (@фамилия_студента nvarchar(50) = null, @название_предмета nvarchar(50) = null)
returns table
as return (
    select с.номер_студента, с.фамилия, с.имя, п.название_предмета, з.оценка
    from студенты с
    inner join записи_на_факультативы з on с.номер_студента = з.номер_студента
    inner join предметы п on з.номер_предмета = п.номер_предмета
    where (с.фамилия = @фамилия_студента or @фамилия_студента is null) and (п.название_предмета = @название_предмета or @название_предмета is null)
);
go

select * from dbo.студентыпредметы(null, null) where номер_студента = 1;
select * from dbo.студентыпредметы('кулешов', null);
select * from dbo.студентыпредметы(null, 'математика');
go

go
create function актпредмет (@названиепредмета nvarchar(50) = null)
returns int
as
begin
    declare @количество int = 0;
    if @названиепредмета is null
    begin
        select @количество = count(distinct номер_студента)
        from записи_на_факультативы;
    end
    else
    begin
        select @количество = count(distinct знф.номер_студента)
        from записи_на_факультативы знф
        inner join предметы п on знф.номер_предмета = п.номер_предмета
        where п.название_предмета = @названиепредмета;
    end
    return @количество;
end;
go

select p.название_предмета, dbo.актпредмет(p.название_предмета) as количество_записанных
from (select distinct название_предмета from предметы) p;
select dbo.актпредмет(null) as всего_активных_студентов;
go