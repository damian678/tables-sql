--1
create table nabywca (
kod number(4) primary key,
nazwa varchar2(15),
nip varchar2(12),
adres varchar2(40));

create table faktura(
nr_faktury number(4) primary key,
data_wystawienia date default sysdate,
wartosc number(10,2),
platnosc varchar2(1) check(platnosc='p' or platnosc='k' or platnosc='g'),
dla_kogo number(4));

create table towar(
id_towaru number(3) primary key,
nazwa varchar(30),
stan number (10,2) check (stan>=0));

create table towar_na_fakturze (
nr_faktury number(4) references faktura,
id_towaru number(3) references towar,
ilosc number (10,2) check (ilosc>0),
primary key(nr_faktury,id_towaru));

--2
insert into nabywca values (1,'xxx','123','Ró¿ana 2');
insert into nabywca values ((select max(kod) from nabywca)+1,'yyy','153','Polna 22');
insert into nabywca values ((select max(kod) from nabywca)+1,'zzz','12223','Nad 2');
insert into nabywca values ((select max(kod) from nabywca)+1,'aaa','123123','Sokola 2');
select * from nabywca;

--3
insert into towar values (1,'xxx',12.2);
insert into towar values ((select max(id_towaru) from towar)+1,'yyy',13);
insert into towar values ((select max(id_towaru) from towar)+1,'aaa',23);
insert into towar values ((select max(id_towaru) from towar)+1,'lll',53);
insert into towar values ((select max(id_towaru) from towar)+1,'www',13.22);
insert into towar values ((select max(id_towaru) from towar)+1,'ttt',0.75);
select * from towar;

--4
alter table nabywca add kraj varchar2(15);

--5
update nabywca set kraj='Polska';

--6
update nabywca set kraj='Niemcy' where kod=(select max(kod) from nabywca);

--7
insert into nabywca values((select max(kod) from nabywca)+1,'Microsoft','09821','New York 20','USA');

--8
update towar set stan=stan+100 where id_towaru in (2,3,5);

--9
alter table nabywca modify adres varchar2(50);

--10
delete from nabywca where kraj='Niemcy';

--11
create view nabywcy_z_polski as
select * from nabywca where kraj='Polska'
with check option;

--12
insert into nabywcy_z_polski values((select max(kod) from nabywcy_z_polski)+1,'ddd','3123','¯arnowiecka 2','Polska');
insert into nabywcy_z_polski values((select max(kod) from nabywcy_z_polski)+1,'nnn','312345','Polna 222','Niemcy');-- nie wykona siê!

--13
alter view nabywcy_z_polski compile;

--14
create sequence sekwencja
start with 10;

--15
select * from towar;
insert into towar values(sekwencja.nextval,'Telewizor',2);

--16
drop sequence sekwencja;

--17
drop view nabywcy_z_polski;
--18

drop table nabywca cascade constraints;
drop table towar cascade constraints;
drop table faktura cascade constraints;
drop table towar_na_fakturze cascade constraints;
