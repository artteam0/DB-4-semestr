use lab042

go
create procedure PFIRST
as begin
declare @k int=(select count(*) from записи_на_факультативы);
select * from записи_на_факультативы;
return @k
end;

declare @k1 int=0;
exec @k1 = PFIRST;
print 'записи: '+cast(@k1 as varchar(3));

go

create procedure PSECOND
	@p char(10)
	as declare @rc int=0;
begin try
	declare @tv char(20), @t char(500)='';
	declare predm cursor for select предметы.название_предмета from предметы where название_предмета = @p;
	if not exists (select предметы.название_предмета from предметы where название_предмета = @p)
		raiserror(52, 52, 52, 52, 52);
	else
		open predm;
		fetch predm into @tv;
		print 'предметы: '
		while @@FETCH_STATUS=0
			begin
				set @t=rtrim(@tv)+', '+@t;
				set @rc=@rc+1
				fetch predm into @rc;
			end;
		print @t;
		close predm;
		return @rc;
end try
begin catch
	print 'ошибка в параметрах' 
    if error_procedure() is not null   
	print 'имя процедуры : ' + error_procedure();
    return @rc;
end catch;

declare @rc1 int;
exec @rc1 = PSECOND @p = 'ООП';
print 'кол-во предметов: '+cast(@rc1 as varchar(3));

go
create procedure PTHIRD
	@a int, @b nvarchar(50), @c int, @d int, @e int
	as declare @rc int=1;
begin try
	set transaction isolation level serializable
	begin tran
		insert into предметы values(@a, @b, @c, @d, @e);
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
exec @rc1=PTHIRD @a=100, @b='qqq', @c=100, @d=100;
print 'код ошибки: '+cast(@rc1 as varchar(3));