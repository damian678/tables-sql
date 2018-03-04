create table nabywcy (
kod number(4) primary key,
nazwa varchar2(15) not null,
nip varchar2(10),
adres varchar2(40) not null);

drop table nabywcy cascade constraints;

create table faktury(
nr_faktury number(4) primary key,
data_wystawienia date default sysdate,
wartosc number(10,2) not null,
platnosc varchar2(1) check (platnosc='p' or platnosc='q'),
dla_kogo number(4) not null references nabywcy);
drop table faktury cascade constraints;

create table towary(
id_towaru number(3) primary key,
nazwa varchar2(30) not null,
stan number(10,2) not null check (stan>=0)
);
create table towary_na_fakturze (
nr_faktury number(4) references faktury,
nr_towaru number(3)references towary,
ilosc number(10,2) not null check (ilosc>0),
primary key (nr_faktury,nr_towaru)
);

insert into nabywcy values (1,'A','3102','Polna 160');
insert into nabywcy values((select max(kod)from nabywcy)+1,'B','3124','Ró¿ana 12');
insert into nabywcy values ((select max(kod)from nabywcy)+1,'C','1354','Ro¿na 2');
insert into nabywcy values ((select max(kod)from nabywcy)+1,'D','1235','Dobra 55');
insert into nabywcy (kod,nazwa,adres) values ((select max(kod)from nabywcy)+1,'E','Dolna 3');
insert into nabywcy values ((select max(kod)from nabywcy)+1,'E',1242,'Kolejowa 2';)
insert into nabywcy values ((select max(kod)from nabywcy)+1,'F',2234,123155);
insert into nabywcy values ('66','G',1242,'XXXX');

insert into towary values(1,'Sól',10.22);
insert into towary values((select max(id_towaru) from towary)+1,'Pieprz',14.22);
insert into towary values((select max(id_towaru) from towary)+1,'Owoce',41.22);
insert into towary values((select max(id_towaru) from towary)+1,'Chleb',12);
insert into towary values((select max(id_towaru) from towary)+1,'Maka',21.22);

alter table nabywcy add kraj varchar2(15);
update nabywcy set kraj='Polska';
alter table nabywcy modify kraj not null;

update nabywcy set kraj='Niemcy' where kod=(select max(kod) from nabywcy);
insert into nabywcy (kod,nazwa,adres,kraj) values((select max(kod) from nabywcy)+1,'H','Polna 411','Francja');
update towary set stan=stan+100 where id_towaru in (2,3,5);

alter table nabywcy modify adres varchar2(50);
delete from nabywcy where kraj='Niemcy';

create view nabywcy_z_polski as
select * from nabywcy where kraj='Polska'
with read only;
select * from nabywcy_z_polski;

create view nabywcy_zagraniczny as
select * from nabywcy where kraj not in ('Polska');

select * from nabywcy_zagraniczny;

insert into nabywcy_zagraniczny values(123,'das',12315,'qwr','Niemcy');
select * from nabywcy;
drop view nabywcy_zagraniczny;

create sequence sekwencja
start with 10;

insert into towary values(sekwencja.nextval,'Oregano',144);

drop sequence sekwencja;
drop view nabywcy_z_polski;
drop table nabywcy cascade constraints;
drop table faktury cascade constraints;
drop table towary cascade constraints;
drop table towary_na_fakturze cascade constraints;

---------------------------------------------------------------------------------
create table wydz as
select * from firma.wydzialy;
alter table prac add primary key(id_prac);
alter table prac modify placa_dodatkowa check (placa_dodatkowa>0);
alter table prac modify placa_podstawowa check (placa_podstawowa>0);
alter table prac modify data_zatrudnienia date default sysdate;
select id_kierownika from wydz;
alter table wydz add unique (id_kierownika);

select to_date('2000/10/22')from dual;