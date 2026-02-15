use UNIVER1

go
create or alter procedure PAUDITORIUM_INSERTX
	@a char(20), @n varchar(50), @c int=0, @t char(10), @tn varchar(50)
	as declare @rc int=1;
begin try
	set transaction isolation level serializable;
	begin tran
	insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
	values(@t, @tn);

	exec @rc =dbo.PAUDITORIUM_INSERTX @a, @n, @c, @t;
		commit tran;
	return @rc;
end try
begin catch 
    print 'номер ошибки: ' + cast(error_number() as varchar(6));
    print 'сообщение: ' + error_message();
    print 'уровень: ' + cast(error_severity()  as varchar(6));
    print 'метка: ' + cast(error_state()   as varchar(8));
    print 'номер строки: ' + cast(error_line()  as varchar(8));
    if error_procedure() is not  null   
		print 'имя процедуры : ' + error_procedure();
    if @@trancount > 0 rollback tran ; 
    return -1;	  
end catch;

declare @rc1 int;
exec @rc1 = PAUDITORIUM_INSERTX @a = '222-2', @n = 'ЛБ-К', @c = 25, @t = '222-2', @tn = 'Лабораторная';
print 'код ошибки: '+cast(@rc1 as varchar(3));