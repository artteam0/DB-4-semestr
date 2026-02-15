use UNIVER2;

--1--
select g.PROFESSION, p.SUBJECT, avg(NOTE)[AVG_NOTE]
from FACULTY f, STUDENT s, GROUPS g, PROGRESS p
where f.FACULTY = '“Œ¬'
group by PROFESSION, SUBJECT;

select g.PROFESSION, p.SUBJECT, avg(NOTE)[AVG_NOTE]
from FACULTY f, STUDENT s, GROUPS g, PROGRESS p
where f.FACULTY = '“Œ¬'
group by
rollup (g.PROFESSION, p.SUBJECT);

--2--
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from FACULTY f, STUDENT s, GROUPS g, PROGRESS p
where f.FACULTY = '“Œ¬'
group by 
cube (g.PROFESSION, p.SUBJECT);

--3--
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '“Œ¬'
group by g.PROFESSION, p.SUBJECT
union
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '’“Ë“'
group by g.PROFESSION, p.SUBJECT;

select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '“Œ¬'
group by g.PROFESSION, p.SUBJECT
union all
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '’“Ë“'
group by g.PROFESSION, p.SUBJECT;

--4--
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '“Œ¬'
group by g.PROFESSION, p.SUBJECT
intersect
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '’“Ë“'
group by g.PROFESSION, p.SUBJECT;

--5--
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '“Œ¬'
group by g.PROFESSION, p.SUBJECT
except
select g.PROFESSION, p.SUBJECT, avg(p.NOTE)[AVG_NOTE]
from STUDENT s, GROUPS g, PROGRESS p
where g.FACULTY = '’“Ë“'
group by g.PROFESSION, p.SUBJECT;