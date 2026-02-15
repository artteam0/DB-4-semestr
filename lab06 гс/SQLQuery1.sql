use UNIVER2

--1--
select atype.AUDITORIUM_TYPE,
max (AUDITORIUM_CAPACITY)[MAX_CAPACITY],
avg (AUDITORIUM_CAPACITY)[AVG_CAPACITY],
min (AUDITORIUM_CAPACITY)[MIN_CAPACITY]
from AUDITORIUM a inner join AUDITORIUM_TYPE atype on a.AUDITORIUM_TYPE = atype.AUDITORIUM_TYPE
group by atype.AUDITORIUM_TYPE;

--2--
select atype.AUDITORIUM_TYPE,
max (a.AUDITORIUM_CAPACITY)[MAX_CAPACITY],
avg (a.AUDITORIUM_CAPACITY)[AVG_CAPACITY],
min (a.AUDITORIUM_CAPACITY)[MIN_CAPACITY],
sum(a.AUDITORIUM_CAPACITY)[TOTAL_CAPACITY],
count(AUDITORIUM_CAPACITY)[COUNT_AUDIT]
from AUDITORIUM a inner join AUDITORIUM_TYPE atype on a.AUDITORIUM_TYPE = atype.AUDITORIUM_TYPE
group by atype.AUDITORIUM_TYPE;

--3--
select *
from(select case when NOTE between 6 and 9 then NOTE
				 end [NOTES], count(*) [AMOUNT]
	 from PROGRESS where NOTE between 6 and 9
	 group by case when NOTE between 6 and 9 then NOTE end) as N
order by NOTES desc;

--4--
select g.YEAR_FIRST, g.PROFESSION, f.FACULTY,
round(avg(cast(NOTE as float(4))), 2)[AVG_NOTE]
from PROGRESS p 
inner join STUDENT s on p.IDSTUDENT = s.IDSTUDENT
inner join GROUPS g on s.IDGROUP = g.IDGROUP
inner join FACULTY f on f.FACULTY = g.FACULTY
group by g.YEAR_FIRST,g.PROFESSION, f.FACULTY

--5--
select g.YEAR_FIRST, g.PROFESSION, f.FACULTY,
round(avg(cast(NOTE as float(4))), 2)[AVG_NOTE]
from PROGRESS p 
inner join STUDENT s on p.IDSTUDENT = s.IDSTUDENT
inner join GROUPS g on s.IDGROUP = g.IDGROUP
inner join FACULTY f on f.FACULTY = g.FACULTY
where p.SUBJECT = 'ÑÓÁÄ' or p.SUBJECT = 'ÎÀèÏ'
group by g.YEAR_FIRST,g.PROFESSION, f.FACULTY

--6--
select g.PROFESSION, p.SUBJECT,
avg(p.NOTE)[AVG_NOTES]
from PROGRESS p 
inner join STUDENT s on p.IDSTUDENT = s.IDSTUDENT
inner join GROUPS g on s.IDGROUP = g.IDGROUP
inner join FACULTY f on f.FACULTY = g.FACULTY
where f.FACULTY = 'ÒÎÂ'
group by g.PROFESSION, p.SUBJECT

--7--
select p.SUBJECT,
 count(*)[STUDENTS]
from PROGRESS p
group by SUBJECT
having sum(CASE WHEN NOTE IN (8, 9) THEN 1 ELSE 0 END) > 0
order by SUBJECT;