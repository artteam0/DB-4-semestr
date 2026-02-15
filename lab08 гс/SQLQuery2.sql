use lab042
go

drop view [students];
drop view [Студенты по адресу];
drop view [Лекций более 30 часов];
drop view [Лекций более 30 часов check];
drop view [5 предметов по лекциям];
go
--1
create view [students]
as
select 
номер_студента as [Код], 
фамилия as [Фамилия], 
имя as [Имя], 
отчество as [Отчество], 
адрес as [Адрес], 
номер_телефона as [Телефон]
from студенты;
go

select * from [Студенты];
go
--2
create view [Студенты по адресу]
as 
select адрес as [Адрес],
count(*) as [Кол-во студентов]
from студенты
group by адрес;
go

select * from [Студенты по адресу];
go
--3
create view [Лекций более 30 часов]
as 
select 
номер_предмета, 
название_предмета, 
объем_лекций
from предметы
where объем_лекций > 30;
go

select * from [Лекций более 30 часов];
go
--4
create view [Лекций более 30 часов check]
as 
select 
номер_предмета, 
название_предмета, 
объем_лекций
from предметы
where объем_лекций > 30
with check option;
go

select * from [Лекций более 30 часов check];
go
--5
create view [5 предметов по лекциям]
as 
select top 5 
номер_предмета, 
название_предмета, 
объем_лекций
from предметы
order by объем_лекций desc;
go

select * from [5 предметов по лекциям];
go
--6
alter view [Студенты по адресу] with schemabinding
as 
select адрес, count(2) as [Кол_во_студентов]
from dbo.студенты
group by адрес;
go

select * from [Студенты по адресу];
go
