use UNIVER1;
select * from TEACHER;
create table TR_AUDIT
(
	ID int identity,
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300)
)

create or alter trigger TR_TEACHER_INS on TEACHER after INSERT
as declare @a1 varchar(5), @a2 varchar(50), @a3  varchar(1), @a4 varchar(5), @in varchar(300);
print 'Операция встаки';
set @a1 = (select [Teacher] from inserted);
set @a2 = (select [Teacher_name] from inserted);
set @a3 = (select [GENDER] from inserted);
set @a4 = (select [PULPIT] from inserted);
set @in = @a1 + '; ' + @a2 + '; ' + @a3 + '; ' + @a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS','TRIG_TR_AUDIT', @in);
return;
go
insert into TEACHER values('lvk1', 'll vv kk' , 'м','ИСиТ');
select * from TR_AUDIT;



create or alter trigger TR_TEACHER_DEL on TEACHER after delete
as declare @a1 varchar(5), @a2 varchar(50), @a3  varchar(1), @a4 varchar(5), @in varchar(300);
print 'Операция удаления';
set @a1 = (select [Teacher] from deleted);
set @a2 = (select [Teacher_name] from deleted);
set @a3 = (select [GENDER] from deleted);
set @a4 = (select [PULPIT] from deleted);
set @in = @a1 + '; ' + @a2 + '; ' + @a3 + '; ' + @a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL','TRIG_TR_AUDIT', @in);
return;
go
delete from TEACHER where TEACHER = 'lvk';
select * from TR_AUDIT;

create or alter trigger TR_TEACHER_DEL on TEACHER after update
as declare @a1 varchar(5), @a2 varchar(50), @a3  varchar(1), @a4 varchar(5), @in varchar(300);
print 'Операция удаления';
set @a1 = (select [Teacher] from inserted);
set @a2 = (select [Teacher_name] from inserted);
set @a3 = (select [GENDER] from inserted);
set @a4 = (select [PULPIT] from inserted);
set @in = @a1 + '; ' + @a2 + '; ' + @a3 + '; ' + @a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD','TRIG_TR_AUDIT', @in);
return;
go
update TEACHER set TEACHER='testtea' where TEACHER='lvk1'
select * from TR_AUDIT;


go
create trigger TR_TEACHER  on TEACHER after INSERT, DELETE, UPDATE  
as declare @a1 varchar(20), @a2 varchar(50), @a3 Varchar(1), @a4 varchar(10), @in varchar(300);
declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 
if  @ins > 0 and  @del = 0  
begin 
     print 'Событие: INSERT';
     set @a1 = (select [Teacher] from inserted);
	 set @a2 = (select [Teacher_name] from inserted);
	 set @a3 = (select [GENDER] from inserted);
	 set @a4 = (select [PULPIT] from inserted);
     set @in = @a1 + '; ' + @a2 + '; ' + @a3 + '; ' + @a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS','TRIG_TR_AUDIT', @in);
end; 
else		  	 
if @ins = 0 and  @del > 0  
begin 
print 'Событие: DELETE';
    set @a1 = (select [Teacher] from deleted);
	 set @a2 = (select [Teacher_name] from deleted);
	 set @a3 = (select [GENDER] from deleted);
	 set @a4 = (select [PULPIT] from deleted);
     set @in = @a1 + '; ' + @a2 + '; ' + @a3 + '; ' + @a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL','TRIG_TR_AUDIT', @in);
end; 
else	  
if @ins > 0 and  @del > 0  
begin 
    print 'Событие: UPDATE'; 
    set @a1 = (select [Teacher] from inserted);
	 set @a2 = (select [Teacher_name] from inserted);
	 set @a3 = (select [GENDER] from inserted);
	 set @a4 = (select [PULPIT] from inserted);
     set @in = @a1 + '; ' + @a2 + '; ' + @a3 + '; ' + @a4;
     set @a1 = (select [Teacher] from deleted);
	 set @a2 = (select [Teacher_name] from deleted);
	 set @a3 = (select [GENDER] from deleted);
	 set @a4 = (select [PULPIT] from deleted);
     set @in = @a1 + '; ' + @a2 + '; ' + @a3 + '; ' + @a4;
    insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD','TRIG_TR_AUDIT', @in);
end;  
return;  
go
insert into TEACHER values('ex4', 'ex4' , 'м','ИСиТ');
update TEACHER set TEACHER = 'test' where TEACHER = 'ex4';
delete from TEACHER where TEACHER = 'test';
select * from TR_AUDIT;


select * from AUDITORIUM;
alter table AUDITORIUM  add constraint AUDITORIUM_CAPACITY check(AUDITORIUM_CAPACITY >= 15)
go 	
update AUDITORIUM set AUDITORIUM_CAPACITY = 10 where AUDITORIUM = '111-1';



go
create trigger TR_TEACHER_DEL1 on TEACHER after UPDATE  
       as print 'TR_TEACHER_DEL1';
 return;  
go 
create trigger TR_TEACHER_DEL2 on TEACHER after UPDATE  
       as print 'TR_TEACHER_DEL2';
return;  
go  
create trigger TR_TEACHER_DEL3 on TEACHER after UPDATE  
       as print 'TR_TEACHER_DEL3';
 return;  
go    

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order = 'First', @stmttype = 'UPDATE';
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order = 'Last', @stmttype = 'UPDATE';
UPDATE TEACHER SET TEACHER_NAME = TEACHER_NAME WHERE TEACHER = 'T1';



select * from AUDITORIUM;
go
create trigger ex7trigger 
	on AUDITORIUM after insert, delete, update
	as declare @c int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM);
	if (@c >=150)
begin
	raiserror('больше 150', 10, 1);
	rollback;
end;
return;
go
update AUDITORIUM set AUDITORIUM_CAPACITY = 200 where AUDITORIUM = '111-1';

use UNIVER;

go
create or alter  trigger DDL_UNIVER on database for CREATE_TABLE, DROP_TABLE  
as  begin
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 

       print 'Тип события: '+@t;
       print 'Имя объекта: '+@t1;
       print 'Тип объекта: '+@t2;
       raiserror( N'операции с таблицами запрещены', 16, 1);  
       rollback;    
end;

CREATE TABLE TESTTEST (
    ID INT
);
GO
DROP TABLE AUDITORIUM;
GO