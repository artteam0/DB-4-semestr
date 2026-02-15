use UNIVER2;

--1
declare @str char(100), @final char(500) = '';
declare subjects cursor for select SUBJECT 
							from SUBJECT
							where PULPIT like 'ИСиТ';
open subjects
fetch subjects into @str;
print 'Дисциплины';
while @@FETCH_STATUS = 0
	begin
		set @final = rtrim(@str) + ', '+@final;
		fetch subjects into @str;
	end;
print @final;
close subject;

deallocate subjects

--2
declare subjects cursor local 
					for select SUBJECT 
						from SUBJECT
						where PULPIT like 'ИСиТ';

declare @str1 char(100), @final1 char(500) = '';
open subjects;
fetch subjects into @str1;
print 'Дисциплины1';
while @@FETCH_STATUS = 0
	begin
		set @final1 = rtrim(@str1) + ', '+@final1;
		fetch subjects into @str1;
	end;
print @final1;
go

declare @str2 char(100), @final2 char(500) = '';
open subjects;
fetch subjects into @str2;
print 'Дисциплины2';
while @@FETCH_STATUS = 0
	begin
		set @final2 = rtrim(@str2) + ', '+@final2;
		fetch subjects into @str2;
	end;
print @final2;
go

--global
declare subjectsGL cursor global 
					for select SUBJECT 
						from SUBJECT
						where PULPIT like 'ИСиТ';

declare @str1 char(100), @final1 char(500) = '';
open subjectsGL;
fetch subjectsGL into @str1;
print 'Дисциплины1';
while @@FETCH_STATUS = 0
	begin
		set @final1 = rtrim(@str1) + ', '+@final1;
		fetch subjectsGL into @str1;
	end;
print @final1;
go


declare @str2 char(100), @final2 char(500) = '';
open subjectsGL;
fetch subjectsGL into @str2;
print 'Дисциплины2';
while @@FETCH_STATUS = 0
	begin
		set @final2 = rtrim(@str2) + ', '+@final2;
		fetch subjectsGL into @str2;
	end;
print @final2;
go

CLOSE subjectsGL;
DEALLOCATE subjectsGL;

--3
declare subjectsStatic cursor local static
					for select SUBJECT 
						from SUBJECT
						where PULPIT like 'ИСиТ';

declare @str1 char(100), @final1 char(500) = '';
open subjectsStatic;
	fetch subjectsStatic into @str1;
	insert SUBJECT(SUBJECT, SUBJECT_NAME, PULPIT) values ('MATH', 'Mathematics', 'ИСиТ');	print 'Дисциплины1';
	while @@FETCH_STATUS = 0
		begin
			set @final1 = rtrim(@str1) + ', '+@final1;
			fetch subjectsStatic into @str1;
		end;
	print @final1;
close subjectsStatic;

declare subjectsDynamic cursor local dynamic
					for select SUBJECT 
						from SUBJECT
						where PULPIT like 'ИСиТ';
declare @str2 char(100), @final2 char(500) = '';
open subjectsDynamic;
	fetch subjectsDynamic into @str2;
	insert SUBJECT(SUBJECT, SUBJECT_NAME, PULPIT) values ('MATH', 'Mathematics', 'ИСиТ');
	print 'Дисциплины2';
	while @@FETCH_STATUS = 0
		begin
			set @final2 = rtrim(@str2) + ', '+@final2;
			fetch subjectsDynamic into @str2;
		end;
	print @final2;
close subjectsDynamic;

--4
declare @row_num int, @subject_name char(100);

declare scroll_cursor cursor local dynamic scroll
for 
    select 
        row_number() over (order by subject) as row_num,
        subject
    from subject
    where pulpit = 'ИСиТ';

open scroll_cursor;

fetch first from scroll_cursor into @row_num, @subject_name;
print 'первая строка      : ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

fetch next from scroll_cursor into @row_num, @subject_name;
print 'следующая строка   : ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

fetch last from scroll_cursor into @row_num, @subject_name;
print 'последняя строка   : ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

fetch prior from scroll_cursor into @row_num, @subject_name;
print 'предыдущая строка  : ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

fetch absolute 2 from scroll_cursor into @row_num, @subject_name;
print 'абсолютная 2 строка: ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

fetch absolute -3 from scroll_cursor into @row_num, @subject_name;
print '3-я строка от конца: ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

fetch relative 2 from scroll_cursor into @row_num, @subject_name;
print '2 строки вперед    : ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

fetch relative -1 from scroll_cursor into @row_num, @subject_name;
print '1 строка назад     : ' + cast(@row_num as varchar(3)) + ' ' + rtrim(@subject_name);

close scroll_cursor;
deallocate scroll_cursor;

--5
use UNIVER1;
declare student_cursor cursor local dynamic scroll
for 
    select IDSTUDENT, SUBJECT, NOTE
    from PROGRESS
    where NOTE < 4
    for update;

declare @idstudent int, @subject varchar(50), @note int;

open student_cursor;

fetch next from student_cursor into @idstudent, @subject, @note;

delete from PROGRESS
where current of student_cursor;

print 'Удалена запись: студент ' + cast(@idstudent as varchar) + 
      ', предмет ' + @subject + ', оценка ' + cast(@note as varchar);

fetch next from student_cursor into @idstudent, @subject, @note;

update PROGRESS
set NOTE = NOTE + 1
where current of student_cursor;

print 'Обновлена запись: студент ' + cast(@idstudent as varchar) + 
      ', предмет ' + @subject + ', новая оценка ' + cast(@note + 1 as varchar);

close student_cursor;
deallocate student_cursor;

--6
delete p
from PROGRESS p
--join STUDENT s on p.IDSTUDENT = s.IDGROUP
--join GROUPS g on s.IDGROUP = g.IDGROUP
where p.NOTE < 4;

print 'Удалены все записи с оценками ниже 4';

update PROGRESS
set NOTE = case when NOTE < 5 then NOTE + 1 else NOTE end
where IDSTUDENT = 1001;

print 'Оценка студента с ID 123 увеличена на 1 (если была меньше 5)';