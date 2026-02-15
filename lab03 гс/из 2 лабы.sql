create database lab042

use lab042
create table студенты(
номер_студента int primary key,
фамилия nvarchar(50),
имя nvarchar(50),
отчество nvarchar(50),
адрес nvarchar(50),
номер_телефона numeric(18)
)on FG2;

create table предметы(
номер_предмета int primary key,
название_предмета nvarchar(50),
объем_лекций int,
объем_практических_занятий int,
объем_лабораторных_работ int
) on FG2;

create table записи_на_факультативы(
номер_записи int primary key,
номер_предмета int,
номер_студента int,
оценка int
) on FG2;

insert into студенты
values
(1, 'Кулешов', 'Артем', 'Алексеевич', 'Панченко', 80445538895),
(2, 'Рауба', 'Арсений', 'Владимирович', 'Белоруссская', 80445252525),
(3, 'Дмитроченко', 'Кирилл', 'Денисович', 'Бобруйская', 80444242424),
(4, 'Статько', 'Герман', 'Вячеславович', 'Хоружей', 80296639874),
(5, 'Лужецкий', 'Владислав', 'Константинович', 'Бобруйская', 80441226989),
(6, 'Старовойтов', 'Илья', 'Сергеевич', 'Партизанский', 80259985536),
(7, 'Александрович', 'Илья', 'Александрович', 'Любимова', 80445532525);

insert into предметы
values
(1, 'Математика', 30, 20, 10),
(2, 'Химия', 40, 30, 20),
(3, 'Иностранный язык', 20, 20, 10),
(4, 'Математика', 20, 80, 40),
(5, 'Биология', 30, 42, 18),
(6, 'Астрономия', 40, 20, 10),
(7, 'БД', 40, 60, 38),
(8, 'ООП', 80, 40, 10),
(9, 'СЯП', 10, 20, 10),
(10, 'ТПвИ', 40, 50, 10);

insert into записи_на_факультативы
values
(1, 1, 1, 10),
(2, 1, 2, 9),
(3, 1, 3, 8),
(4, 2, 1, 7),
(5, 2, 2, 6),
(6, 2, 3, 5),
(7, 3, 1, 4),
(8, 3, 2, 3),
(9, 3, 3, 2);

alter table студенты add дата_поступления date;
alter table студенты drop column дата_поступления;

select * from студенты;
select count(*) from студенты;
select фамилия from студенты where номер_студента>1;

update предметы set название_предмета = 'Физика' where номер_предмета = 1;

create database lab0422 on primary
(name='labmdf11111', filename='D:\уник\4 сем\БД\lab03\labmbf11111.mdf',
size=10240KB, maxsize=1GB, filegrowth=25%),
filegroup FG2
(name='labndf11111', filename='D:\уник\4 сем\БД\lab03\labndf11111.ndf',
size=10240KB, maxsize=1GB, filegrowth=25%)
log on
(name='lablog11111', filename='D:\уник\4 сем\БД\lab03\lablog11111.ldf',
size=10240KB, maxsize=1GB, filegrowth=10%)

use lab0422
create table auditorium(
auditorium char(20) primary key,
auditorium_type char(10),
auditorium_capacity int default 1
check (auditorium_capacity between 1 and 300),
auditorium_name nvarchar(50)
) on FG2;