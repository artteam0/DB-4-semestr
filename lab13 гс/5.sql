use UNIVER1

go
create procedure SUBJECT_REPORT
	@p char(10)
	as declare @rc int=0;
begin try
	declare @tv char(20), @t char(300)='';
	declare subj cursor for select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT=@p;
	if not exists(select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = @p)
		raiserror('ошибка', 11, 1);
	else
		open subj;
		fetch subj into @tv;
		print 'предметы: ';
		while @@FETCH_STATUS=0
			begin
				set @t=rtrim(@tv)+', '+@t;
				set @rc=@rc+1;
				fetch subj into @tv;
			end;
		print @t;
		close subj;
		return @rc;
end try
begin catch
    print 'ошибка в параметрах' 
    if error_procedure() is not null   
	print 'имя процедуры : ' + error_procedure();
    return @rc;
end catch; 

declare @rc1 int;
   exec @rc1 = SUBJECT_REPORT @p = 'ИСиТ';
   print 'Кол-во предметов: ' + cast(@rc1 as varchar(3));