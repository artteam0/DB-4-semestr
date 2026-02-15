use UNIVER1

go
create procedure PSUBJECT
as
begin
declare @k int;
select @k = count(*) from STUDENT;
SELECT COUNT(*) AS k FROM SUBJECT;
END;
exec PSUBJECT;
