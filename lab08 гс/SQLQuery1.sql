use UNIVER1
go

drop view [Преподаватель];
drop view [Количество кафедр];
drop view [Аудитории];
drop view [Лекционные_аудитории];
drop view [Дисциплины];
go

--1
create view [Преподаватель]
as
select
    t.TEACHER[КОД], 
    t.TEACHER_NAME[ИМЯ], 
    t.GENDER[ПОЛ], 
    t.PULPIT[КОД КАФЕДРЫ]
from TEACHER t;
go

select * from [Преподаватель];
go
--2
create view [Количество кафедр]
as 
select f.FACULTY[Факультет],
count(p.PULPIT)[Кол-во кафедр]
from FACULTY f inner join PULPIT p on f.FACULTY = p.FACULTY
group by f.FACULTY;
go

select * from [Количество кафедр]
go
--3
create view [Аудитории]
as 
select a.AUDITORIUM_TYPE, a.AUDITORIUM_NAME
from AUDITORIUM a
where a.AUDITORIUM_TYPE like 'ЛК%';
go

select * from [Аудитории]
go
--4
create view [Лекционные_аудитории]
as 
select a.AUDITORIUM_TYPE, a.AUDITORIUM_NAME
from AUDITORIUM a
where a.AUDITORIUM_TYPE like 'ЛК%'
with check option;
go

select * from [Лекционные_аудитории]
go
--5
create view [Дисциплины]
as 
select top 150 s.SUBJECT, s.SUBJECT_NAME, s.PULPIT
from SUBJECT s
order by s.SUBJECT;
go

select * from [Дисциплины]
go
--6
alter view [Количество кафедр] with schemabinding	
as 
select f.FACULTY[Факультет],
count(p.PULPIT)[Кол-во кафедр]
from dbo.FACULTY f join dbo.PULPIT p on f.FACULTY = p.FACULTY
group by f.FACULTY;
go

select * from [Количество кафедр]
go