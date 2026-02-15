use lab042

declare @str char(100), @final char(500)=''
declare names cursor for select фамилия from студенты
open names
fetch names into @str;
print 'Фамилии:';
while  @@FETCH_STATUS=0
begin 
	set @final = rtrim(@str)+', ' + @final;
	fetch names into @str;
end;
print @final;
close names;
deallocate names;
go

declare namesLocal cursor local for select фамилия from студенты
declare @str char(100), @final char(500)='';
open namesLocal
fetch namesLocal into @str;
while @@FETCH_STATUS=0
begin
	set @final=rtrim(@str) + ', ' + @final;
	fetch namesLocal into @str;
end;
print @final;
go

declare namesGlobal cursor global for select фамилия from студенты
declare @str char(100), @final char(500)='';

open namesGlobal
fetch namesGlobal into @str
while @@FETCH_STATUS=0
begin
	set @final=rtrim(@str)+', '+@final;
	fetch namesGlobal into @str
end;
print @final;
go
deallocate namesGlobal;

declare @str char(100), @final char(500) = '';
open namesGlobal;
fetch namesGlobal into @str;

declare staticCursor cursor local static for select название_предмета from предметы where название_предмета like 'Математика';
declare @predmet nvarchar(20), @final1 nvarchar(500)='';
fetch staticCursor into @predmet;

insert into предметы values (11, 'Русский язык', 10, 10, 10);
print 'Статический курсор: ';
while @@FETCH_STATUS=0
begin 
	set @final1=rtrim(@predmet)+', '+@final1;
	fetch staticCursor into @predmet;
end;
print @final1;
deallocate staticCursor;
go

declare dynamicCursor cursor local dynamic for select название_предмета from предметы where название_предмета like 'Математика';
declare @predmet nvarchar(20), @final1 nvarchar(500)='';
open dynamiсСursor;
fetch dynamicCursor into @predmet;

insert into предметы values (12, 'Белорусский язык', 10, 10, 10);
print 'Динамический курсор: ';
while @@FETCH_STATUS=0
begin 
	set @final1=rtrim(@predmet)+', '+@final1;
	fetch dynamicCursor into @predmet;
end;
print @final1;
deallocate dynamicCursor;


declare @row_num int, @subject_name nvarchar(50);
declare scroll_cursor cursor local dynamic scroll
for select row_number() over (order by название_предмета) as row_num, название_предмета from предметы;
open scroll_cursor;

fetch first from scroll_cursor into @row_num, @subject_name;
print N'первая строка        : ' + cast(@row_num as varchar) + N' ' + @subject_name;

fetch next from scroll_cursor into @row_num, @subject_name;
print N'следующая строка     : ' + cast(@row_num as varchar) + N' ' + @subject_name;

fetch last from scroll_cursor into @row_num, @subject_name;
print N'последняя строка     : ' + cast(@row_num as varchar) + N' ' + @subject_name;

fetch prior from scroll_cursor into @row_num, @subject_name;
print N'предыдущая строка    : ' + cast(@row_num as varchar) + N' ' + @subject_name;

fetch absolute 2 from scroll_cursor into @row_num, @subject_name;
print N'абсолютная 2 строка  : ' + cast(@row_num as varchar) + N' ' + @subject_name;

fetch absolute -3 from scroll_cursor into @row_num, @subject_name;
print N'3-я строка от конца  : ' + cast(@row_num as varchar) + N' ' + @subject_name;

fetch relative 2 from scroll_cursor into @row_num, @subject_name;
print N'2 строки вперед      : ' + cast(@row_num as varchar) + N' ' + @subject_name;

fetch relative -1 from scroll_cursor into @row_num, @subject_name;
print N'1 строка назад       : ' + cast(@row_num as varchar) + N' ' + @subject_name;

close scroll_cursor;
deallocate scroll_cursor;


declare student_cursor cursor local dynamic scroll
for select номер_студента, номер_предмета, оценка from записи_на_факультативы where оценка < 4 for update;
declare @idstudent int, @idpredmet int, @note int;

open student_cursor;

fetch next from student_cursor into @idstudent, @idpredmet, @note;

delete from записи_на_факультативы
where current of student_cursor;

print N'Удалена запись: студент ' + cast(@idstudent as varchar) + 
      N', предмет ' + cast(@idpredmet as varchar) + N', оценка ' + cast(@note as varchar);

fetch next from student_cursor into @idstudent, @idpredmet, @note;

update записи_на_факультативы
set оценка = оценка + 1
where current of student_cursor;

print N'Обновлена запись: студент ' + cast(@idstudent as varchar) + 
      N', предмет ' + cast(@idpredmet as varchar) + N', новая оценка ' + cast(@note + 1 as varchar);

close student_cursor;
deallocate student_cursor;

delete z
from записи_на_факультативы z
join студенты s on z.номер_студента = s.номер_студента
where z.оценка < 4;

print N'Удалены все записи с оценками ниже 4';

update записи_на_факультативы
set оценка = case when оценка < 5 then оценка + 1 else оценка end
where номер_студента = 1;

print N'Оценка студента с ID 1 увеличена на 1 (если была меньше 5)';
