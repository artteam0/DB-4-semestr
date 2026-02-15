use UNIVER1

go
create procedure PAUDITORIUM_INSERT
	@a char(20), @n varchar(50), @c int=0, @t char(10)
	as declare @rc int =1;
begin try
	insert into AUDITORIUM (AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM_CAPACITY, AUDITORIUM.AUDITORIUM_NAME)
	values(@a, @n, @c, @t)
	return @rc;
end try

begin catch
print 'номер ошибки: '+cast(error_number() as varchar(6));
print 'сообщение: ' +error_message();
print 'уровень: '+cast(error_severity() as varchar(6));
print 'метка: '+cast(error_state() as varchar(6));
print 'номер строки: '+cast(error_line() as varchar(8));
 if error_procedure() is not null
 print 'имя процедуры: ' + error_procedure();
 return -1;
end catch;

declare @rc1 int;
exec @rc1=PAUDITORIUM_INSERT @a='206-1', @n='ЛБ', @c=60, @t='206-1';
print 'код ошибки: '+cast(@rc1 as varchar(3));

select*from AUDITORIUM
