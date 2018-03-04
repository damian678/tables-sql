--1
create table towary (
id number(4,0) not null primary key,
nazwa varchar2(30) not null,
jednostka varchar2(3) not null,
opis varchar2(50));

create table magazyny (
id varchar2(1) not null primary key,
nazwa varchar2(10) not null,
adres varchar2(30) not null);

create table zamowienia (
numer number(4,0) not null primary key,
data date not null,
magazyn varchar2(1) not null);

create table zam_jedn (
numer_zam number(4,0) not null,
id_towaru number(4,0) not null,
cena number(6,2) not null,
ilosc number(4,2) not null,
primary key(numer_zam,id_towaru));

--2
insert into towary values (1,'D¿em','l',null);
insert into towary values (2,'Mak','kg',null);
insert into magazyny values ('1','Magazyn 1','Polna 2');
insert into magazyny values ('2','Magazyn 2','Zielona 3');
insert into zamowienia values (1,'17/12/15','1',null);
insert into zamowienia values (2,'17/12/14','2',null);
insert into zam_jedn values (1,1,23,4);
insert into zam_jedn values (2,2,35,6);

--3
alter table zamowienia add foreign key (magazyn) references magazyny;
alter table zam_jedn add foreign key (numer_zam) references zamowienia;
alter table zam_jedn add foreign key (id_towaru) references towary;

--4
alter table zam_jedn add check (cena>0);
alter table zam_jedn add check (ilosc>0);

--5
alter table zamowienia modify data null;

--6
alter table zamowienia modify data default sysdate;

--7
alter table zamowienia add uwagi varchar2(100);

--8
update zamowienia set uwagi='P³atnoœæ przelewem' where data>'11/11/20';

--9
alter table zam_jedn modify ilosc number(5,2);

--10
alter table towary drop column opis;

--11
delete from towary where id not in (select numer from zamowienia);

--12
create sequence seq_towary
start with 3;
insert into towary values (seq_towary.nextval, 'xxx','m');

--13
create view towary_a as
select nazwa,data from towary join zam_jedn on towary.id=zam_jedn.id_towaru join zamowienia on
zam_jedn.numer_zam=zamowienia.numer where magazyn=1;

--14
create view towary_na_szt as
select id,nazwa,jednostka from towary where jednostka='szt';

--15
insert into towary_na_szt values(seq_towary.nextval,'Chleb','l');
select * from towary_na_szt;
drop table zam_jedn cascade constraints;