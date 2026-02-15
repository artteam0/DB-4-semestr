use UNIVER1

go
ALTER procedure [dbo].[PSUBJECT] @p varchar(20)
	as begin
		declare @k int = (select count(*) from SUBJECT);
		select * from SUBJECT where SUBJECT.PULPIT = @p;
	end;
go

create table #SUBJECT (
	SUBJECT varchar(10) primary key,
	SUBJECT_NAME varchar(50),
	PULPIT varchar(10)
)

insert #SUBJECT exec [dbo].[PSUBJECT] @p = '»—Ë“';
insert #SUBJECT exec [dbo].[PSUBJECT] @p = 'À”';
select * from #SUBJECT;
